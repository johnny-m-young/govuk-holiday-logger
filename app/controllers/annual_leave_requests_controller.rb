require "status_update"

class AnnualLeaveRequestsController < ApplicationController
  def new
    @annual_leave_request = AnnualLeaveRequest.new
  end

  def check
    @date_from = format_date_params(check_leave_request_params[:date_from])
    @date_to = format_date_params(check_leave_request_params[:date_to])
    @days_required = WorkingDaysCalculator.new(@date_from, @date_to).number_of_working_days
  end

  def create
    @annual_leave_request = current_user.annual_leave_requests.build(annual_leave_request_params)

    if @annual_leave_request.save
      @email_response_notification = notify_client.send_email(new_request_email_hash)
      redirect_to annual_leave_request_confirmation_path
    else
      render "new"
    end
  end

  def confirm; end

  def approve
    line_reports_leave_requests = AnnualLeaveRequest.where(user: current_user.line_reports)
    @annual_leave_request = line_reports_leave_requests.find(params[:annual_leave_request_id])
  end

  def deny
    line_reports_leave_requests = AnnualLeaveRequest.where(user: current_user.line_reports)
    @annual_leave_request = line_reports_leave_requests.find(params[:annual_leave_request_id])
  end

  def update_status
    line_reports_leave_requests = AnnualLeaveRequest.where(user: current_user.line_reports)
    @annual_leave_request = line_reports_leave_requests.find(params[:annual_leave_request_id])

    if @annual_leave_request.update(annual_leave_request_params)
      @email_response_notification = notify_client.send_email(status_update.email_hash)
      redirect_to status_update.confirmation_page_path
    else
      render status_update.action
    end
  end

  def confirm_approval; end

  def confirm_denial; end

private

  def format_date_params(date)
    "#{date[:day]}/#{date[:month]}/#{date[:year]}".to_date
  end

  def check_leave_request_params
    params.require(:annual_leave_request).permit(date_from: %i[day month year], date_to: %i[day month year])
  end

  def annual_leave_request_params
    params.require(:annual_leave_request).permit(:date_from, :date_to, :days_required, :status, :confirm_approval, :denial_reason)
  end

  def status_update
    case @annual_leave_request.status
    when "approved"
      ApprovedStatusUpdate
    when "denied"
      DeniedStatusUpdate
    end.new(@annual_leave_request)
  end

  def new_request_email_hash
    {
      email_address: line_manager.email,
      template_id: "1587d50b-c12e-4698-b10e-cf414de26f36",
      personalisation: {
        line_manager_name: "#{line_manager.given_name} #{line_manager.family_name}",
        name: "#{user.given_name} #{user.family_name}",
        date_from: @annual_leave_request.date_from.to_fs(:rfc822),
        date_to: @annual_leave_request.date_to.to_fs(:rfc822),
        days_required: @annual_leave_request.days_required,
      },
    }
  end

  def notify_client
    @notify_client ||= Notifications::Client.new(ENV["NOTIFY_API_KEY"])
  end

  def line_manager
    @annual_leave_request.user.line_manager
  end

  def user
    @annual_leave_request.user
  end
end
