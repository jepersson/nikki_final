require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_posts
    make_relations
    make_comments
  end
end

def make_users
  User.create!(:name => "Example User",
               :email => "example@gmail.com",
               :intro => "Hej du glade galosh",
               :password => "password",
               :password_confirmation => "password")
  9.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@gmail.com"
    intro = Faker::Lorem.sentence(15)
    password = "password-#{n+1}"
    User.create!(:name => name,
                 :email => email,
                 :intro => intro,
                 :password => password,
                 :password_confirmation => password)
  end
end  

def make_posts
  User.all(:limit => 9).each do |user|
    2.times do
      title = Faker::Lorem.sentence(1)
      content = Faker::Lorem.sentence(10)
      longitude = (rand()*10+40)
      latitude = (rand()*10+40)
      user.posts.create!(:title => title, :content => content, :longitude => longitude, :latitude => latitude)
    end
  end
end

def make_relations
  users = User.all
  user  = users.first
  following = users[2..30]
  followers = users[3..20]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_comments
  Post.all(:limit => 5).each do |post|
    User.all(:limit => 5).each do |user|
      content = Faker::Lorem.sentence(2)
      user.comments.create!(:post_id => post.id, :content => content)
    end
  end
end