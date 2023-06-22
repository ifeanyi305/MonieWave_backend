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

@fee_range1 = FeeRange.new(start_price: 1, end_price: 300, fee: 1)
@fee_range2 = FeeRange.new(start_price: 301, end_price: 500, fee: 2)
@fee_range3 = FeeRange.new(start_price: 501, end_price: 1000, fee: 3.5)
@fee_range4 = FeeRange.new(start_price: 1001, end_price: 10000000, fee: 4)

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

@transfer1 = Transfer.new(amount: "14", currency: "Pounds",
                    exchange_rate: 820, naira_amount: "₦11,480.00", payment_method: "Bank transfer",
                    recipient_account: "7067255308", recipient_bank: "PALMPAY", fee: 2, recipient_name: "IFY oti",
                    recipient_phone: "7067255308", reference_number: "MnTH3J", user_id: 1, status: "Pending")

@transfer2 = Transfer.new(amount: "500", currency: "Euro",
                    exchange_rate: 820, naira_amount: "₦50,480.00", payment_method: "Bank transfer",
                    recipient_account: "7067255308", recipient_bank: "KUDA", fee: 3, recipient_name: "Val Blaze",
                    recipient_phone: "8055813654", reference_number: "MnTH3J", user_id: 2, status: "Processing", processing_time: Time.now.utc)

@transfer3 = Transfer.new(amount: "1500", currency: "Pounds",
                    exchange_rate: 970, naira_amount: "₦250,480.00", payment_method: "Bank transfer",
                    recipient_account: "7067255308", recipient_bank: "First Bank", fee: 3.5, recipient_name: "Apostle Comrade",
                    recipient_phone: "9044766184", reference_number: "MnTH3J", user_id: 1, status: "Processing", processing_time: Time.now.utc)

if  @transfer1.save! && @transfer2.save! && @transfer3.save!
  puts "User transfers successfully created"
end


@beneficiary = Beneficiary.new(bank_name: "Kuda", account_number: "7067255308", account_name: "OTI Ifeanyi", phone_number: "07056926583", user_id: 1)

if @beneficiary.save!
  puts "New beneficiary created"
end