require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class GravatarIconTest < Test::Unit::TestCase

  def test_initialize
    with_eschaton do |script|
      assert_eschaton_output :gravatar do
                               Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com'
                            end

      assert_eschaton_output :gravatar_with_size do
                              Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com', :size => 50
                            end

      assert_eschaton_output :gravatar_with_default_icon do
                              Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com', :default => 'http://localhost:3000/images/blue.png'
                            end

      assert_eschaton_output :gravatar_with_size_and_default_icon do
                              Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com', :default => 'http://localhost:3000/images/blue.png',
                                                       :size => 50
                            end
    end
  end
  
  def test_gravatar_image_url
    with_eschaton do |script|    
    gravatar_icon = Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com'
    
    assert_equal "http://www.gravatar.com/avatar/9cbd681f28890259e8025d970bc515a3",
                  gravatar_icon.image_url(:email_address => 'yawningman@eschaton.com')

    assert_equal "http://www.gravatar.com/avatar/9cbd681f28890259e8025d970bc515a3?size=50",
                 gravatar_icon.image_url(:email_address => 'yawningman@eschaton.com', :size => 50)

    assert_equal "http://www.gravatar.com/avatar/9cbd681f28890259e8025d970bc515a3?default=http://localhost:3000/images/blue.png",
                 gravatar_icon.image_url(:email_address => 'yawningman@eschaton.com', 
                                    :default => 'http://localhost:3000/images/blue.png')

    assert_equal "http://www.gravatar.com/avatar/9cbd681f28890259e8025d970bc515a3?default=http://localhost:3000/images/blue.png&size=50",
                 gravatar_icon.image_url(:email_address => 'yawningman@eschaton.com', :default => 'http://localhost:3000/images/blue.png',
                                    :size => 50)
    end
  end
  

end
