class CartsController < ApplicationController

  def show
    @cart = find_or_create_cart
    render json: cart_payload(@cart), status: :ok
  end

  def create
    @cart = find_or_create_cart

    @product = Product.find_by(id: params[:product_id])
    if @product.nil?
      return render json: {message: 'Product not found'}, status: :not_found
    end

    if @cart.products.find_by(id: @product.id).present?
      return render json: {message: 'Product already in the cart'}, status: :bad_request
    end

    quantity = params[:quantity]

    @cart_item = CartItem.new(cart: @cart, product: @product, quantity: quantity)

    if @cart_item.save
      @cart.calculate_total_price
      @cart.update_last_interaction_time
      render json: cart_payload(@cart), status: :created
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  def add_items
    @cart = find_or_create_cart

    @cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    if @cart_item.nil?
      return render json: { message: 'Product not in the cart' }, status: :bad_request
    end

    final_quantity = @cart_item.quantity + params[:quantity].to_i
    if final_quantity.positive?
      @cart_item.update!(quantity: final_quantity)
    else
      @cart_item.destroy!
    end

    @cart.update_last_interaction_time
    @cart.calculate_total_price

    render json: cart_payload(@cart), status: :ok
  end

  def destroy
    @cart = find_cart

    if @cart.nil?
      return render json: {message: 'Cart not found'}, status: :not_found
    end

    @cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    if @cart_item.nil?
      return render json: { message: 'Product not in the cart' }, status: :bad_request
    end

    @cart_item.destroy!
    @cart.calculate_total_price
    @cart.update_last_interaction_time

    render json: cart_payload(@cart), status: :ok
  end

  private

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