require 'rails_helper'

RSpec.describe CartsController, type: :request do

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

  describe "GET /cart" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, price: 10) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    context 'when the cart does not exist' do
      subject { get '/cart', as: :json }

      it 'creates a new cart' do
        expect { subject }.to change(Cart, :count).from(1).to(2)
      end
    end

    context 'when the cart exists' do
      before do
        allow_any_instance_of(described_class).to receive(:session).and_return({ cart_id: cart.id })
      end

      subject { get '/cart', as: :json }

      it 'returns the cart' do
        subject
        expect(JSON.parse(response.body)).to include({'id' => cart.id})
      end
    end
  end

  describe "DELETE /carts/:product_id" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, price: 10) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    context 'when the product is in the cart' do
      before do
        allow_any_instance_of(described_class).to receive(:session).and_return({ cart_id: cart.id })
      end

      subject { delete "/carts/#{product.id}", as: :json }

      it 'removes the product from the cart' do
        expect { subject }.to change(CartItem, :count).by(-1)
      end
    end
  end

  describe "POST /carts/add_items" do
    let(:cart) {create(:cart)}
    let(:product) {create(:product, price: 10)}
    let!(:cart_item) {create(:cart_item, cart: cart, product: product, quantity: 1)}

    context 'when the product already is in the cart' do
      before do
        allow_any_instance_of(described_class).to receive(:session).and_return({ cart_id: cart.id })
      end

      subject do
        post '/carts/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/carts/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
end
