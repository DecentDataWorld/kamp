# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

puts 'ROLES'
roles = ['admin','user','member']
roles.each do |role|
  Role.find_or_create_by :name => role
  puts 'role: ' << role
end
puts 'DEFAULT TAGS'
puts 'DEFAULT USERS'
user = User.find_or_create_by :email => ENV['ADMIN_EMAIL'].dup
user.name = ENV['ADMIN_NAME'].dup
user.password = ENV['ADMIN_PASSWORD'].dup
user.password_confirmation = ENV['ADMIN_PASSWORD'].dup
user.save
puts 'user: ' << user.name
user.confirm
user.add_role :admin
new_resource = Resource.find_or_create_by :name => 'First Resource'
#new_resource.tag_list = ENV['TAGS']
new_resource.author = user
new_resource.save
new_resource.delete

