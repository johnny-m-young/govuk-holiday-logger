module UserHelper
  def line_reports_table_rows(line_reports)
    rows = []

    line_reports.each do |line_report|
      rows << [
        {
          text: "#{line_report.given_name} #{line_report.family_name}",
        },
        {
          # TODO: Update this so that it says "Pending requests" if a line report has
          # annual leave requests in "Pending" status and "No requests" if not.
          text: sanitize("<strong class='govuk-tag'> PLACEHOLDER FOR STATUS </strong>"),
        },
        {
          text: "Manage requests",
        },
      ]
    end

    rows
  end
end
