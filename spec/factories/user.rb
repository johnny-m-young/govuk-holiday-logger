FactoryBot.define do
  factory(:user) do
    given_name { "John" }
    family_name { "Smith" }
    email { "john.smith@digital.cabinet-office.gov.uk" }
    password { "password with $ymb0l$" }
    annual_leave_remaining { 27.5 }
  end
end
