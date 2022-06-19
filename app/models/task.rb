class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  # ransack gemをオーバーライドし検索対象を制限する
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  # ransack gemをオーバーライドし検索条件に含める関連を指定する
  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
  
end
