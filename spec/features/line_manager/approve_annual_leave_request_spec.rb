require "spec_helper"

RSpec.feature "Line manager can approve an annual leave request" do
  setup do
    notify_test_client = Notifications::Client.new(ENV["NOTIFY_TEST_API_KEY"])
    allow_any_instance_of(AnnualLeaveRequestsController).to receive(:notify_client).and_return(notify_test_client) # rubocop:disable RSpec/AnyInstance
  end

  scenario do
    given_i_am_signed_in_as_a_line_manager
    and_my_line_report_has_a_pending_leave_request
    when_i_visit_the_line_reports_dashboard
    and_i_click_manage_requests
    and_i_approve_the_pending_request
    then_the_request_status_updates_to_approved
  end

  def given_i_am_signed_in_as_a_line_manager
    @line_manager = create(:user)
    @line_report = create(:user, line_manager_id: @line_manager.id)
    sign_in @line_manager
  end

  def and_my_line_report_has_a_pending_leave_request
    @pending_request = create(:annual_leave_request, user_id: @line_report.id)
    assert(@pending_request.status, "pending")
  end

  def when_i_visit_the_line_reports_dashboard
    visit root_path
    click_link "Your line reports"
  end

  def and_i_click_manage_requests
    click_link "Manage requests"
    expect(page).to have_content("#{@line_report.given_name} #{@line_report.family_name}")
  end

  def and_i_approve_the_pending_request
    click_link "Approve"
    expect(page).to have_content("Approve annual leave request")

    check "annual_leave_request[confirm_approval]"
    click_button "Approve leave"
  end

  def then_the_request_status_updates_to_approved
    expect(page).to have_content("Annual leave request approved")
    @pending_request.reload
    expect(@pending_request.status).to eq("approved")
  end
end
