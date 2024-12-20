class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0
  has_many :cart_items
  has_many :products, through: :cart_items

  def calculate_total_price
    self.total_price = cart_items.sum(&:total_price)
  end

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado

end
