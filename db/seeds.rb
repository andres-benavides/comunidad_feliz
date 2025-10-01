# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# frozen_string_literal: true

puts "Seeding users..."
u1 = User.find_or_create_by!(name: "Alice",  banned: false)
u2 = User.find_or_create_by!(name: "Bob",    banned: false)
u3 = User.find_or_create_by!(name: "Charlie", banned: false)

puts "Seeding books..."
b1 = Book.find_or_create_by!(title: "Clean Code",    author: "Robert C. Martin")
b2 = Book.find_or_create_by!(title: "The Pragmatic Programmer", author: "Andrew Hunt & David Thomas")
b3 = Book.find_or_create_by!(title: "Refactoring",  author: "Martin Fowler")

puts "Users:  #{User.count} | Books: #{Book.count}"
