require "spec_helper"

RSpec.feature "Sign in" do
  scenario do
    given_i_have_sign_in_details
    when_i_go_to_the_sign_in_page
    and_i_fill_in_the_sign_in_form
    then_i_am_successfully_signed_in
  end

  def given_i_have_sign_in_details
    @user = create(:user)
    assert @user.valid?
  end

  def when_i_go_to_the_sign_in_page
    visit new_user_session_path
    expect(page).to have_content("Sign in to GOV.UK Holiday Logger")
  end

  def and_i_fill_in_the_sign_in_form
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Sign in"
  end

  def then_i_am_successfully_signed_in
    expect(page).to have_content("#{@user.given_name} #{@user.family_name}'s Dashboard")
  end
end
