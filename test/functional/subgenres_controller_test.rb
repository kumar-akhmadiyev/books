require 'test_helper'

class SubgenresControllerTest < ActionController::TestCase
  setup do
    @subgenre = subgenres(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subgenres)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subgenre" do
    assert_difference('Subgenre.count') do
      post :create, subgenre: { title: @subgenre.title }
    end

    assert_redirected_to subgenre_path(assigns(:subgenre))
  end

  test "should show subgenre" do
    get :show, id: @subgenre
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subgenre
    assert_response :success
  end

  test "should update subgenre" do
    put :update, id: @subgenre, subgenre: { title: @subgenre.title }
    assert_redirected_to subgenre_path(assigns(:subgenre))
  end

  test "should destroy subgenre" do
    assert_difference('Subgenre.count', -1) do
      delete :destroy, id: @subgenre
    end

    assert_redirected_to subgenres_path
  end
end
