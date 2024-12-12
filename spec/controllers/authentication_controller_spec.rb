# spec/controllers/authentication_controller_spec.rb
require 'rails_helper'

include JsonWebToken

RSpec.describe AuthenticationController, type: :controller do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }

  describe 'POST #login' do
    context 'with valid credentials' do
      it 'logs in the user and sets the session token' do
        post :login, params: { email: 'user@example.com', password: 'password' }
        expect(session[:token]).to be_present
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid credentials' do
      it 'does not log in the user and renders the login page' do
        post :login, params: { email: 'user@example.com', password: 'wrongpassword' }
        expect(session[:token]).to be_nil
        expect(response).to render_template('users/login')
        expect(flash[:alert]).to eq('Incorrect email or password.')
      end
    end
  end

  describe 'POST #register' do
    context 'with valid attributes' do
      it 'registers a new user and logs them in' do
        post :register, params: { user: { email: 'newuser@example.com', password: 'password', password_confirmation: 'password' } }
        expect(User.find_by(email: 'newuser@example.com')).to be_present
        expect(session[:token]).to be_present
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not register a new user and renders the registration page' do
        post :register, params: { user: { email: '', password: 'password' } }
        expect(User.find_by(email: '')).to be_nil
        expect(response).to render_template('users/register')
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #logout' do
    it 'logs out the user and clears the session token' do
      session[:token] = 'some_token'
      delete :logout
      expect(session[:token]).to be_nil
      expect(response).to redirect_to(users_login_path)
      expect(flash[:notice]).to eq('Logged out successfully.')
    end
  end
end