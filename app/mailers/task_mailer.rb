class TaskMailer < ApplicationMailer
  # taskleafアプリケーションからのメールのアドレスデフォルト設定
  default from: 'taskleaf@example.com'

  def creation_email(task)
    @task = task
    mail(
      subject: 'タスク作成完了メール',
      to: 'user@example.com',
      from: 'taskleaf@example.com'
    )
  end
end
