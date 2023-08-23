require "spec_helper"

RSpec.feature "Sign out" do
  scenario do
    given_i_am_signed_in
    when_i_click_the_sign_out_link
    then_i_am_successfully_signed_out
  end
end

def given_i_am_signed_in
  @user = create(:user)
  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_button "Sign in"

  expect(page).to have_content("#{@user.given_name} #{@user.family_name}'s Dashboard")
end

def when_i_click_the_sign_out_link
  click_link "Sign out"
end

def then_i_am_successfully_signed_out
  visit root_path
  expect(page).to have_content("Sign in to GOV.UK Holiday Logger")
  expect(page).to have_current_path("/users/sign_in")
end
