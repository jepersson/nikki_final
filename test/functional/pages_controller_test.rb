require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  tests HighVoltage::PagesController

  %w(help about contact).each do |page|
    context "on GET to /#{page}" do
      setup { get :show, :id => page }

      should respond_with :success
      should render_template page
    end
  end
end
