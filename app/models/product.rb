class Product < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: {minimum:20}
  validates :price, presence: true, numericality: { greater_than: 0 }

  validate :validate_name

  def validate_name
    name.present?
  end
end

