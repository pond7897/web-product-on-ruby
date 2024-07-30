require "test_helper"

class ProductTest < ActionDispatch::IntegrationTest
  test "should able to show list products" do
    get "/products"
    
    assert_response 200
    assert_select "h1", "List Products"
    assert_select "ul" do 
      assert_select "h2", 2
      assert_select "h2", "pancake"
      assert_select "h2", "coke"
    end
  end

  test "should able to show specified product" do
    product1 = products(:pancake)

    get "/products/#{product1.id}"

    assert_response 200
    assert_select 'h1', "pancake"
    assert_select 'p', "pancake is a very good"
    assert_select 'p', "30.0"
  end
  
  test "should able to create the product" do
    get "/products/new"
    assert_response 200
    
    post "/products", params: { product: { name: "coca", description: "the water is very good", price: 15 } }
    
    assert_response 302
    follow_redirect!
    assert_response 200
  end

  test "should not able to create the product if name is empty" do
    post "/products", params: { product: { name: "", description: "the water is a very delicious", price: 20 } }

    # debugger
    assert_response 422
    assert_select 'div', 'Name can\'t be blank'
  end
  
  test "should not able to create the product if description is empty" do
    post "/products", params: { product: { name: "coca", description: "", price: 20 } }

    assert_response 422
    assert_select 'div', 'Description can\'t be blank'
  end

  test "should not able to create the product if description is too short" do
    post "/products", params: { product: { name: "coca", description: "the water", price: 20 } }

    assert_response 422
    assert_select 'div', 'Description is too short (minimum is 20 characters)'
  end

  test "should not able to create the product if price lower than 0" do
    post "/products", params: { product: { name: "coca", description: "the water is very good", price: -20 } }

    assert_response 422
    assert_select 'div', 'Price must be greater than 0'
  end

  test "should able to update product name pancake to cake" do
    product1 = products(:pancake)
    
    assert_changes -> { product1.reload.name }, from: "pancake", to: "cake" do
      patch "/products/#{product1.id}", params: { product: { name: "cake" } }

      assert_response 302
    end
  end

  test "xxxshould able to destroy" do 

    product1 = products(:pancake)
    
    assert_difference "Product.count", -1 do
      delete "/products/#{product1.id}"

      assert_response 303
    end
    
  end
end
