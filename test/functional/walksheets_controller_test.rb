require 'test_helper'

class WalksheetsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Walksheet.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Walksheet.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Walksheet.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to walksheet_url(assigns(:walksheet))
  end
  
  def test_edit
    get :edit, :id => Walksheet.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Walksheet.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Walksheet.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Walksheet.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Walksheet.first
    assert_redirected_to walksheet_url(assigns(:walksheet))
  end
  
  def test_destroy
    walksheet = Walksheet.first
    delete :destroy, :id => walksheet
    assert_redirected_to walksheets_url
    assert !Walksheet.exists?(walksheet.id)
  end
end
