require "spec_helper"

RSpec.feature "User can view annual leave remaining" do
  scenario do
    given_i_have_sign_in_details
    and_i_am_signed_in
    when_i_visit_the_homepage
    then_i_can_see_my_remaining_annual_leave_entitlement
  end

  def given_i_have_sign_in_details
    @user = create(:user)
  end

  def and_i_am_signed_in
    sign_in @user
  end

  def when_i_visit_the_homepage
    visit root_path
  end

  def then_i_can_see_my_remaining_annual_leave_entitlement
    expect(page).to have_content(@user.annual_leave_remaining)
  end
end
