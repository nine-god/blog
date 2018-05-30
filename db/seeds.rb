# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Role.create(name: 'guest',admin: false,publish_articles: false,publish_comments: true) unless Role.find_by_name('guest')
Role.create(name: 'user',admin: false,publish_articles: true,publish_comments: true) unless Role.find_by_name('user')
Role.create(name: 'admin',admin: true,publish_articles: true,publish_comments: true) unless Role.find_by_name('admin')

if Rails.env == 'test'
	
end