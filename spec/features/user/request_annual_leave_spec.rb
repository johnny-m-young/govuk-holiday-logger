require "spec_helper"

RSpec.feature "User can request annual leave" do
  let(:user) { create(:user) }

  scenario do
    given_i_am_signed_in
    when_i_visit_the_homepage
    and_i_click_request_annual_leave
    and_i_fill_in_the_request_form
    and_i_confirm_my_request
    then_an_annual_leave_request_is_created
  end

  def given_i_am_signed_in
    sign_in user
  end

  def when_i_visit_the_homepage
    visit root_path
  end

  def and_i_click_request_annual_leave
    click_link "Request annual leave"
  end

  def and_i_fill_in_the_request_form
    @annual_leave_request = build(:annual_leave_request, user_id: user.id)

    fill_in "annual_leave_request[date_from][day]", with: @annual_leave_request.date_from.day
    fill_in "annual_leave_request[date_from][month]", with: @annual_leave_request.date_from.month
    fill_in "annual_leave_request[date_from][year]", with: @annual_leave_request.date_from.year

    fill_in "annual_leave_request[date_to][day]", with: @annual_leave_request.date_to.day
    fill_in "annual_leave_request[date_to][month]", with: @annual_leave_request.date_to.month
    fill_in "annual_leave_request[date_to][year]", with: @annual_leave_request.date_to.year

    click_button "Continue"
  end

  def and_i_confirm_my_request
    expect(page).to have_content(@annual_leave_request.date_from.to_fs(:rfc822))
    expect(page).to have_content(@annual_leave_request.date_to.to_fs(:rfc822))
    expect(page).to have_content(@annual_leave_request.days_required.to_int)

    click_button "Send request"
  end

  def then_an_annual_leave_request_is_created
    expect(user.annual_leave_requests.count).to eq(1)
    expect(page).to have_content("Request sent")
  end
end
