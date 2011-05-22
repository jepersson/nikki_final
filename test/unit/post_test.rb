require 'test_helper'

class PostTest < ActiveSupport::TestCase
  should belong_to(:user)
  should have_many(:comments).dependent(:destroy)
  
  should validate_presence_of(:title)
  should validate_presence_of(:content)
  should validate_presence_of(:user_id)
  
  should_not allow_mass_assignment_of(:user_id) 
end
