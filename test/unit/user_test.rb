require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:posts).dependent(:destroy)
  
  should validate_presence_of(:name) 
  should validate_presence_of(:email)
end
