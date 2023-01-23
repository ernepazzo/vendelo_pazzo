class ProductsController < ApplicationController
  skip_before_action :protect_pages, only: [:index, :show]

  def index
    @categories = Category.order(name: :asc).load_async

    @pagy, @products = pagy_countless(FindProducts.new.call(product_params_index).load_async, items: 12)
  end

  def show
    product
  end

  def new
    # @path_action = 'new'
    @product = Product.new
    # @product_action = [@product,@path_action]
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: t('.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @path_action = 'edit'
    authorize! product
    # @product_action = [product,@path_action]
  end

  def update
    authorize! product
    if product.update(product_params)
      redirect_to products_path, notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! product
    product.destroy

    redirect_to products_path, notice: t('.destroyed'), status: :see_other
  end
  
  
  private
  def product_params
    params.require(:product).permit(:title, :description, :price, :photo, :category_id, :min_price, :max_price, :page)
  end

  def product_params_index
    params.permit(:category_id, :min_price, :max_price, :query_text, :order_by, :page)
  end
  
  
  def product
    @product = Product.find(params[:id])
  end  
  
end