class LineReportsController < ApplicationController
  before_action :redirect_if_user_not_line_manager

  def index
    @line_reports = current_user.line_reports
  end

private

  def redirect_if_user_not_line_manager
    redirect_to root_path unless current_user.is_line_manager?
  end
end
