require 'test_helper'

class GisRegionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => GisRegion.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    GisRegion.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    GisRegion.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to gis_region_url(assigns(:gis_region))
  end
  
  def test_edit
    get :edit, :id => GisRegion.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    GisRegion.any_instance.stubs(:valid?).returns(false)
    put :update, :id => GisRegion.first
    assert_template 'edit'
  end
  
  def test_update_valid
    GisRegion.any_instance.stubs(:valid?).returns(true)
    put :update, :id => GisRegion.first
    assert_redirected_to gis_region_url(assigns(:gis_region))
  end
  
  def test_destroy
    gis_region = GisRegion.first
    delete :destroy, :id => gis_region
    assert_redirected_to gis_regions_url
    assert !GisRegion.exists?(gis_region.id)
  end
end
