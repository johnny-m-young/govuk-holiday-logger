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
      helpers.send_new_request_email(@annual_leave_request)
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
      send_status_update_email
      redirect_to_status_update_confirmation_page
    else
      render "approve" if annual_leave_request_params[:status] == "approved"
      render "deny" if annual_leave_request_params[:status] == "denied"
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

  def send_status_update_email
    case annual_leave_request_params[:status]
    when "approved"
      helpers.send_approved_request_email(@annual_leave_request)
    when "denied"
      helpers.send_denied_request_email(@annual_leave_request)
    end
  end

  def redirect_to_status_update_confirmation_page
    case annual_leave_request_params[:status]
    when "approved"
      redirect_to confirm_annual_leave_request_approval_path
    when "denied"
      redirect_to confirm_annual_leave_request_denial_path
    end
  end
end
