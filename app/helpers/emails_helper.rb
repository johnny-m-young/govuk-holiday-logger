module EmailsHelper
  def send_new_request_email(annual_leave_request)
    user = annual_leave_request.user
    line_manager = user.line_manager

    client.send_email(
      email_address: line_manager.email,
      template_id: "1587d50b-c12e-4698-b10e-cf414de26f36",
      personalisation: {
        line_manager_name: "#{line_manager.given_name} #{line_manager.family_name}",
        name: "#{user.given_name} #{user.family_name}",
        date_from: annual_leave_request.date_from.to_fs(:rfc822),
        date_to: annual_leave_request.date_to.to_fs(:rfc822),
        days_required: annual_leave_request.days_required,
      },
    )
  end

  def send_status_updated_email(annual_leave_request)
    case annual_leave_request.status
    when "approved"
      client.send_email(approval_email_hash(annual_leave_request))
    when "denied"
      client.send_email(denial_email_hash(annual_leave_request))
    end
  end

private

  def client
    @client ||= Notifications::Client.new(notify_api_key)
  end

  def notify_api_key
    ENV["NOTIFY_API_KEY"]
  end

  def approval_email_hash(annual_leave_request)
    user = annual_leave_request.user
    line_manager = user.line_manager
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

  def denial_email_hash(annual_leave_request)
    user = annual_leave_request.user
    line_manager = user.line_manager
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
