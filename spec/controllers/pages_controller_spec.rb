# spec/controllers/pages_controller_spec.rb
require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let(:user) { create(:user, email: 'user@example.com') }

  describe 'GET #home' do
    context 'when the user is logged in' do
      before { login_user(user) }

      it 'renders the home page' do
        get :home
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the user is not logged in' do
      it 'redirects to the login page' do
        get :home
        expect(response).to redirect_to(users_login_path)
        expect(flash[:alert]).to eq('You must be logged in to access this page.')
      end
    end
  end
end