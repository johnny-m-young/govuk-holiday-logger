class LineReportsController < ApplicationController
  before_action :redirect_if_user_not_line_manager

  def index
    @line_reports = current_user.line_reports
  end

  def show
    @line_report = User.find_by_id(params[:id])
    @annual_leave_requests = @line_report.annual_leave_requests

    redirect_to root_path if current_user != @line_report.line_manager
  end

private

  def redirect_if_user_not_line_manager
    redirect_to root_path unless current_user.is_line_manager?
  end
end
