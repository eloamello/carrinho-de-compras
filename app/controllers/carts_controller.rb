class CartsController < ApplicationController

  def show
    @cart = find_or_create_cart
    render json: cart_payload(@cart), status: :ok
  end

  def create
    @cart = find_or_create_cart

    @product = Product.find(params[:product_id])
    if @cart.products.find_by(id: @product.id).present?
      return render json: {message: 'Product already in the cart'}, status: :bad_request
    end

    quantity = params[:quantity]

    @cart_item = CartItem.new(cart: @cart, product: @product, quantity: quantity)
    @cart.calculate_total_price

    if @cart_item.save
      @cart.calculate_total_price
      render json: cart_payload(@cart), status: :created
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  def cart_payload(cart)
    products = cart.cart_items.includes(:product).map do |cart_item|
      {
        id: cart_item.product.id,
        name: cart_item.product.name,
        quantity: cart_item.quantity,
        unit_price: cart_item.product.price,
        total_price: cart_item.total_price,
      }
    end

    {
      id: cart.id,
      products: products,
      total_price: cart.total_price
    }
  end

  def find_or_create_cart
    if session[:cart_id].present?
      find_cart || create_new_cart
    else
      create_new_cart
    end
  end

  def find_cart
    Cart.find_by(id: session[:cart_id])
  end

  def create_new_cart
    cart = Cart.create!(total_price: 0)
    session[:cart_id] = cart.id
    cart
  end
end