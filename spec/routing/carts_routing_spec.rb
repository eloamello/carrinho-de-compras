require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/cart').to route_to('carts#show')
    end

    it 'routes to #create' do
      expect(post: '/carts').to route_to('carts#create')
    end

    it 'routes to #destroy' do
      expect(delete: '/carts/product_id').to route_to(controller: 'carts', action: 'destroy', product_id: 'product_id')
    end

    it 'routes to #add_item via POST' do
      expect(post: '/carts/add_items').to route_to('carts#add_items')
    end
  end
end 
