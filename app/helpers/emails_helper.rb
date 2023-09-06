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

  def send_approved_request_email(annual_leave_request)
    user = annual_leave_request.user
    line_manager = user.line_manager

    client.send_email(
      email_address: user.email,
      template_id: "34542d49-8b91-412c-9393-c186a04a7d1c",
      personalisation: {
        line_manager_name: "#{line_manager.given_name} #{line_manager.family_name}",
        name: "#{user.given_name} #{user.family_name}",
        date_from: annual_leave_request.date_from.to_fs(:rfc822),
        date_to: annual_leave_request.date_to.to_fs(:rfc822),
      },
    )
  end

private

  def client
    @client ||= Notifications::Client.new(notify_api_key)
  end

  def notify_api_key
    ENV["NOTIFY_API_KEY"]
  end
end
