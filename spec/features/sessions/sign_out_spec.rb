require "spec_helper"

RSpec.feature "Sign out" do
  scenario do
    given_i_am_signed_in
    when_i_click_the_sign_out_button
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

def when_i_click_the_sign_out_button
  click_button "Sign out"
end

def then_i_am_successfully_signed_out
  visit root_path
  expect(page).not_to have_content("#{@user.given_name} #{@usfamily}'s Dashboard")
end
