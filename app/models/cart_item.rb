class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  after_commit :update_cart

  def total_price
    product.price * quantity
  end

  private

  def update_cart
    cart.calculate_total_price
    cart.update_last_interaction_time
  end
end
