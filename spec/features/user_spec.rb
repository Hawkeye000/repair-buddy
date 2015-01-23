require 'rails_helper'

describe 'Signing up new Users' do

  let(:user_attrs) { attributes_for(:user) }

  it "should permit signing up Users" do
    visit new_user_registration_path
    within("#new_user") {
      fill_in :name, with:user_attrs[:name]
      fill_in :email, with:user_attrs[:email]
      fill_in :password, with:user_attrs[:password]
      fill_in :password_confirmation, with:user_attrs[:password_confirmation]
    }
    expect {
      click_button "Sign up"
    }.to change(User, :count).by(1)

  end

  after do |example|
    if example.exception != nil
      save_and_open_page
    end
  end

end
