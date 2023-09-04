class RootController < ApplicationController
  before_action :redirect_if_user_not_signed_in

  def index
    @annual_leave_requests = current_user.annual_leave_requests.sort_by(&:date_from)
  end

private

  def redirect_if_user_not_signed_in
    redirect_to new_user_session_path unless current_user
  end
end
