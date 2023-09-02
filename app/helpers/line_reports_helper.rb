module LineReportsHelper
  def line_reports_table_rows(line_reports)
    rows = []

    line_reports.each do |line_report|
      rows << [
        {
          text: "#{line_report.given_name} #{line_report.family_name}",
        },
        {
          text: line_report_status(line_report),
        },
        {
          text: "Manage requests",
        },
      ]
    end

    rows
  end

  def line_report_status(user)
    if user.annual_leave_requests.where(status: "pending").any?
      sanitize("<strong class='govuk-tag govuk-tag--red'> Pending requests </strong>")
    else
      sanitize("<strong class='govuk-tag govuk-tag--green'> No pending requests </strong>")
    end
  end
end
