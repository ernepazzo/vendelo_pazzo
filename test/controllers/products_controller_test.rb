require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'render a list of products' do
    get products_path 

    assert_response :success
    assert_select '.product', 2
  end

  test 'render a detailed product page' do
    get product_path(products(:one))

    assert_response :success
    assert_select '.title', 'MyString1'
    assert_select '.description', 'MyText1'
    assert_select '.price', '1$'
  end

  test 'render a new product' do
    get new_product_path

    assert_response :success
    assert_select 'form'
  end

  test 'allow to create a new product' do
    post products_path, params: {
      product: {
        title: 'DDD',
        description: 'dd dd dd',
        price: 54
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product was successfully created'
  end

  test 'does not allow to create a new product with empty fields' do
    post products_path, params: {
      product: {
        title: '',
        description: 'dd dd dd',
        price: 54
      }
    }

    assert_response :unprocessable_entity
  end

  test 'render an edit product' do
    get edit_product_path(products(:one))

    assert_response :success
    assert_select 'form'
  end

  test 'allow to update a product' do
    patch product_path(products(:one)), params: {
      product: {
        price: 123
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product was successfully updated'
  end

  test 'does not allow to update a product with an invalid fiel' do
    patch product_path(products(:one)), params: {
      product: {
        price: nil
      }
    }

    assert_response :unprocessable_entity
  end

  test 'can delete products' do
    assert_difference('Product.count', -1) do
      delete product_path(products(:one))
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product was successfully deleted'
  end
end