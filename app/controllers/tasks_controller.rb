class TasksController < ApplicationController
  protect_from_forgery :except => [:destroy]
  before_action :set_task, only: [:show, :edit, :confirm_edit, :update, :destroy]
  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)

    respond_to do |format|
      # HTMLフォーマット（拡張子なしURL）でのアクセスの場合実行、特に何もしない
      format.html 
      # CSVとしてアクセスされた場合（拡張子csvでアクセス）、実行される
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" } 
    end
  end

  def show
  end

  def new
    @url = confirm_new_task_path
    @task = Task.new
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end
  
  def create
    @task = current_user.tasks.new(task_params)
    @url = confirm_new_task_path

    if params[:back].present?
      render :new
      return
    end
    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      # タスク新規作成後、5分後に通知メールを送信
      # TaskMailer.creation_email(@task).deliver_later(wait: 5.minute)
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    @url = confirm_edit_task_url
  end

  def confirm_edit
    # タスクの内容を確認して、変化がないようならメッセージ付きでrenderする    
    tmp = @task.dup
    @task.assign_attributes(task_params)
    if tmp.name == @task.name && tmp.description == @task.description
      @url = confirm_edit_task_url
      flash[:notice] = "タスクを編集してください。"
      render :edit
    end
    # 不要なflashメッセージを削除する
    flash.discard
    render :edit unless @task.valid?
  end

  def update
    @url = confirm_edit_task_url
    if params[:back].present?
      render :edit
      return
    end

    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスク「#{@task.name}」を削除しました。"
  end

  def import
    # ログインしているユーザーのタスク群としてインポート
    current_user.tasks.import(params[:file])
    redirect_to tasks_url, notice: 'タスクを追加しました。'
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

  def set_task
    if params[:back]
      @task = Task.find(params[:id])
      @task.assign_attributes(task_params) 
    else
      # 存在しないIDのタスクを取得しようとした場合に「そのようなデータは存在しない」と表示
      @task = current_user.tasks.find_by(id: params[:id])
      redirect_to tasks_url, notice: "タスクが存在しません。" if @task.nil?
    end
  end
end
