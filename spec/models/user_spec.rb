require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(email: 'test@example.com', password: 'password', password_confirmation: 'password')
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(password: 'password')
      expect(user).to_not be_valid
    end

    it 'normalizes the email before saving' do
      user = User.create(email: ' TEST@EXAMPLE.COM ', password: 'password')
      expect(user.email).to eq('test@example.com')
    end

    it 'requires a unique email' do
      User.create(email: 'test@example.com', password: 'password')
      duplicate_user = User.new(email: 'test@example.com', password: 'password')
      expect(duplicate_user).to_not be_valid
    end
  end
end