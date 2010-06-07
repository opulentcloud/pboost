require 'test_helper'

class PoliticalCampaignsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => PoliticalCampaign.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    PoliticalCampaign.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    PoliticalCampaign.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to political_campaign_url(assigns(:political_campaign))
  end
  
  def test_edit
    get :edit, :id => PoliticalCampaign.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    PoliticalCampaign.any_instance.stubs(:valid?).returns(false)
    put :update, :id => PoliticalCampaign.first
    assert_template 'edit'
  end
  
  def test_update_valid
    PoliticalCampaign.any_instance.stubs(:valid?).returns(true)
    put :update, :id => PoliticalCampaign.first
    assert_redirected_to political_campaign_url(assigns(:political_campaign))
  end
  
  def test_destroy
    political_campaign = PoliticalCampaign.first
    delete :destroy, :id => political_campaign
    assert_redirected_to political_campaigns_url
    assert !PoliticalCampaign.exists?(political_campaign.id)
  end
end
