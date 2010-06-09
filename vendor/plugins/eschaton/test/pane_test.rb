require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class PaneTest < Test::Unit::TestCase

  def test_initialize
    with_eschaton do |script|
      map = Google::Map.new
      
      assert_eschaton_output 'pane = new GooglePane({cssClass: "pane", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "Poly Jean Harvey is indeed a unique women"});
                             map.addControl(pane);' do
                              map.add_control Google::Pane.new(:html => 'Poly Jean Harvey is indeed a unique women')
                            end

      assert_eschaton_output 'pane = new GooglePane({cssClass: "pane", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(10, 10)), text: "Poly Jean Harvey is indeed a unique women"});
                             map.addControl(pane);' do
                              map.add_control Google::Pane.new(:html => 'Poly Jean Harvey is indeed a unique women', :anchor => :top_right)
                            end
                            
      assert_eschaton_output 'pane = new GooglePane({cssClass: "pane", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(10, 30)), text: "Poly Jean Harvey is indeed a unique women"});
                             map.addControl(pane);' do
                              map.add_control Google::Pane.new(:html => 'Poly Jean Harvey is indeed a unique women', :anchor => :top_right,
                                                               :offset => [10, 30])
                            end
                            
      assert_eschaton_output 'pane = new GooglePane({cssClass: "green", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "Poly Jean Harvey is indeed a unique women"});
                             map.addControl(pane);' do
                              map.add_control Google::Pane.new(:html => 'Poly Jean Harvey is indeed a unique women', :css_class => :green)
                            end
                            
      assert_eschaton_output 'pane = new GooglePane({cssClass: "green", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "test output for render"});
                            map.addControl(pane);' do
                              map.add_control Google::Pane.new(:partial => 'jump_to', :css_class => :green)
                            end
    end
  end
  
  def test_pane_id
    with_eschaton do |script|
      output = 'my_pane = new GooglePane({cssClass: "pane", id: "my_pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "Poly Jean Harvey is indeed a unique women"});'
     
      assert_eschaton_output output do
                              Google::Pane.new(:var => :my_pane, :html => 'Poly Jean Harvey is indeed a unique women')
                            end

      assert_eschaton_output output do
                              Google::Pane.new(:var => 'my_pane', :html => 'Poly Jean Harvey is indeed a unique women')
                            end
    end
  end
  
  def test_replace_html
    with_eschaton do
      pane = Google::Pane.new(:html => 'Poly Jean Harvey is indeed a unique women')

      assert_eschaton_output 'Element.update("pane", "This is new html");',
                            with_eschaton  {
                              pane.replace_html :html => "This is new html" 
                            }

      assert_eschaton_output 'Element.update("pane", "This is new html");',
                            with_eschaton {
                              pane.replace_html "This is new html" 
                            }

      assert_eschaton_output 'Element.update("pane", "test output for render");',
                            with_eschaton {
                              pane.replace_html :partial => 'new_html' 
                            }
    end    
  end
  
end