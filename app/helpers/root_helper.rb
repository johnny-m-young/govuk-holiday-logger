module RootHelper
  def formatted_status(status)
    case status
    when "pending"
      sanitize("<strong class='govuk-tag govuk-tag--yellow'> #{status} </strong>")
    when "approved"
      sanitize("<strong class='govuk-tag govuk-tag--green'> #{status} </strong>")
    when "withdrawn", "denied"
      sanitize("<strong class='govuk-tag govuk-tag--red'> #{status} </strong>")
    end
  end
end
