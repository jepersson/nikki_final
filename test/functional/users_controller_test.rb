require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    get :new
  end
  should respond_with(:success)
  should render_template(:new)
end
