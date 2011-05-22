require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:posts).dependent(:destroy)
  should have_many(:comments).dependent(:destroy)
  should have_many(:following).through(:relations)
  should have_many(:followers).through(:reverse_relations)
  
  should validate_presence_of(:name) 
  
  should validate_presence_of(:email)
  should validate_format_of(:email).with('example@gmail.com')
  should_not allow_value('@gmail.com').for(:email)  
  should_not allow_value('example@gmail.').for(:email)
  should_not allow_value('example@com').for(:email)  

  subject { Factory(:user) }
  should validate_uniqueness_of(:email).case_insensitive
  should validate_uniqueness_of(:name).case_insensitive
  
end
