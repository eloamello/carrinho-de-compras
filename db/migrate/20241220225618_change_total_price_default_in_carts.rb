class ChangeTotalPriceDefaultInCarts < ActiveRecord::Migration[7.1]
  def up
    change_column_default :carts, :total_price, from: nil, to: 0
  end
end
