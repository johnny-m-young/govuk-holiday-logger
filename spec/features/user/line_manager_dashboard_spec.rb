require "spec_helper"

RSpec.feature "Line manager can view their line reports on the line reports dashboard" do
  scenario do
    given_i_am_signed_in_as_a_line_manager
    when_i_visit_the_homepage
    and_i_click_the_line_reports_navbar_item
    then_i_can_see_my_line_reports
  end
end

def given_i_am_signed_in_as_a_line_manager
  @line_manager = create(:user, :line_manager)
  sign_in @line_manager
end

def when_i_visit_the_homepage
  visit root_path
end

def and_i_click_the_line_reports_navbar_item
  click_link "Your line reports"
end

def then_i_can_see_my_line_reports
  expect(page).to have_content("LineReport 0")
  expect(page).to have_content("LineReport 1")
  expect(page).to have_content("LineReport 2")
end
