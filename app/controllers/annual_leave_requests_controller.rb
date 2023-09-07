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
    @annual_leave_request = AnnualLeaveRequest.find(params[:annual_leave_request_id])
    redirect_to root_path if current_user != @annual_leave_request.user.line_manager
  end

  def update_status
    @annual_leave_request = AnnualLeaveRequest.find(params[:annual_leave_request_id])
    redirect_to root_path if current_user != @annual_leave_request.user.line_manager

    if @annual_leave_request.update(annual_leave_request_params)
      helpers.send_approved_request_email(@annual_leave_request)
      redirect_to confirm_annual_leave_request_approval_path
    else
      render "approve"
    end
  end

  def confirm_approval; end

private

  def format_date_params(date)
    "#{date[:day]}/#{date[:month]}/#{date[:year]}".to_date
  end

  def check_leave_request_params
    params.require(:annual_leave_request).permit(date_from: %i[day month year], date_to: %i[day month year])
  end

  def annual_leave_request_params
    params.require(:annual_leave_request).permit(:date_from, :date_to, :days_required, :status, :confirm_approval)
  end
end
