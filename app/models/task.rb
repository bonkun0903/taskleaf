class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  belongs_to :user
  has_one_attached :image

  scope :recent, -> { order(created_at: :desc) }
  # ページネーションの表示件数デフォルトを設定
  # paginates_per 50

  # ransack gemをオーバーライドし検索対象を制限する
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  # ransack gemをオーバーライドし検索条件に含める関連を指定する
  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes  
      # スコープを絞り込んだgenerateの場合はallは何もしない
      all.each do |task|
        csv << csv_attributes.map { |attr| task.send(attr) }
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
  
end
