require 'test_helper'
require 'factories'

class UserTest < ActiveSupport::TestCase
  should have_many(:posts).dependent(:destroy)
  
  should validate_presence_of(:name) 
  
  should validate_presence_of(:email)
  
  should validate_format_of(:email).with('example@gmail.com')
  should_not allow_value('@gmail.com').for(:email)  
  should_not allow_value('example@gmail.').for(:email)
  should_not allow_value('example@com').for(:email)
  
  
  context "a unique email" do
    def setup
      @user = Factory(:user)
    end
    
    should validate_uniqueness_of(:email).case_insensitive
  end
  
end
