require 'rails_helper'

describe "home page" do

  before { visit '/' }

  context "user is not logged in" do
    it "should have a link to login" do
      expect(page).to have_link("Login", href:new_user_session_path)
    end
  end

end
