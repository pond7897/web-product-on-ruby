class Product < ApplicationRecord
  has_many :orders

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 20 }
  validates :price, presence: true, numericality: { greater_than: 0 }
end

