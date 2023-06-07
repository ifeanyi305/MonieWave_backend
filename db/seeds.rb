# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'date'

# Create Admin User
@admin = User.new(
  first_name: 'Admin', last_name: 'Blaze', country: 'Nigeria', email: 'admin@admin.com',
  verified: true, role: 'admin', status: 'Active', last_login: DateTime.now, password: '12345678')

# Create Normal User                  
@user = User.new(
  first_name: 'User', last_name: 'Val', country: 'Nigeria', email: 'user1@test.com',
  verified: true, role: 'customer', status: 'Active', last_login: DateTime.now, password: '12345678')

if @admin.save!
  puts "Admin account created successfully"
  puts @admin.email
  puts @admin.password
end

if @user.save!
  puts "User account created successfully"
  puts @user.email
  puts @user.password
end

# Create Fees

@fee_range1 = FeeRange.new(start_price: 1, end_price: 100, fee: 1)
@fee_range2 = FeeRange.new(start_price: 101, end_price: 300, fee: 2)
@fee_range3 = FeeRange.new(start_price: 501, end_price: 1000, fee: 3.5)
@fee_range4 = FeeRange.new(start_price: 1001, end_price: 100000, fee: 4)

if @fee_range1.save!
  @fee_range2.save!
  @fee_range3.save!
  @fee_range4.save!
  puts "Fee Created Successfully"
end

# Create Exchange rate

@euro_rate = ExchangeRate.new(currency: 'euro', price: 850)
@euro_rate.time = DateTime.now
@euro_rate.day = Time.now.strftime('%A')
@euro_rate.month = Time.now.strftime('%B')

@pounds_rate = ExchangeRate.new(currency: 'pounds', price: 900)
@pounds_rate.time = DateTime.now
@pounds_rate.day = Time.now.strftime('%A')
@pounds_rate.month = Time.now.strftime('%B')

if @euro_rate.save! && @pounds_rate.save!
  puts 'Euro and pounds exchange rate created successfully'
end