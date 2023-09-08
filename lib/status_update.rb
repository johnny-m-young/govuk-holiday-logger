class ApprovedStatusUpdate
  include Rails.application.routes.url_helpers

  attr_reader :annual_leave_request, :user, :line_manager

  def initialize(annual_leave_request)
    @annual_leave_request = annual_leave_request
    @user = annual_leave_request.user
    @line_manager = user.line_manager
  end

  def confirmation_page_path
    confirm_annual_leave_request_approval_path
  end

  def action
    "approve"
  end

  def email_hash
    {
      email_address: user.email,
      template_id: "34542d49-8b91-412c-9393-c186a04a7d1c",
      personalisation: {
        line_manager_name: "#{line_manager.given_name} #{line_manager.family_name}",
        name: "#{user.given_name} #{user.family_name}",
        date_from: annual_leave_request.date_from.to_fs(:rfc822),
        date_to: annual_leave_request.date_to.to_fs(:rfc822),
      },
    }
  end
end

class DeniedStatusUpdate
  include Rails.application.routes.url_helpers

  attr_reader :annual_leave_request, :user, :line_manager

  def initialize(annual_leave_request)
    @annual_leave_request = annual_leave_request
    @user = annual_leave_request.user
    @line_manager = user.line_manager
  end

  def confirmation_page_path
    confirm_annual_leave_request_denial_path
  end

  def action
    "deny"
  end

  def email_hash
    {
      email_address: user.email,
      template_id: "ec9035df-9c98-4e0e-8826-47768c311745",
      personalisation: {
        line_manager_name: "#{line_manager.given_name} #{line_manager.family_name}",
        name: "#{user.given_name} #{user.family_name}",
        date_from: annual_leave_request.date_from.to_fs(:rfc822),
        date_to: annual_leave_request.date_to.to_fs(:rfc822),
        denial_reason: annual_leave_request.denial_reason,
      },
    }
  end
end
