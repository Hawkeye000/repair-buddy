require 'rails_helper'

describe "home page" do

  before { visit '/' }

  context "user is not logged in" do
    it "should have a link to login" do
      expect(page).to have_link("Login", href:new_user_session_path)
    end
  end
  context "user is logged in" do
    before do
      @user = create(:user)
      login_as @user, scope: :user
      visit current_path
    end

    it "should have a link to Profile" do
      expect(page).to have_link("Profile", href:user_path(@user))
    end
  end

  after do |example|
    if example.exception != nil
      save_and_open_page
    end
  end

end
