class AnnualLeaveRequestsController < ApplicationController
  def new
    @annual_leave_request = AnnualLeaveRequest.new
  end
end
