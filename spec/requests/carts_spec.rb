require 'rails_helper'

RSpec.describe CartsController, type: :request do
  pending "TODO: Escreva os testes de comportamento do controller de carrinho necessários para cobrir a sua implmentação #{__FILE__}"

  describe "POST /carts" do
    let(:product) { Product.create(name: "Test Product", price: 10.0) }

    context 'when the product is not in the cart and the cart does not exist' do
      subject { post '/carts', params: { product_id: product.id, quantity: 1 }, as: :json }

      it 'creates a new cart' do
        expect { subject }.to change(Cart, :count).from(0).to(1)
      end

      it 'adds the product to it' do
        subject
        cart = Cart.find_each do |cart|
          expect(cart.products).to include(product)
        end
      end
    end
  end

  xdescribe "POST /carts/add_items" do
    let(:cart) { Cart.create }
    let(:product) { Product.create(name: "Test Product", price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
end
