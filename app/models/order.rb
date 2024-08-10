class Order < ApplicationRecord
  belongs_to :product

  before_validation :calculate_total_price

  private

  def calculate_total_price
    self.total_price = quantity * product.price
  end
end


