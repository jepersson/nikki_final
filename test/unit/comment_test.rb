require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  should should belong_to(:user)
  should should belong_to(:post)
  
  should validate_presence_of(:content)
  should validate_presence_of(:user_id)
  should validate_presence_of(:post_id)
  
  should_not allow_mass_assignment_of(:user_id)
  should_not allow_mass_assignment_of(:post_id)
end
