FactoryBot.define do
  factory(:user) do
    given_name { "John" }
    family_name { "Smith" }
    email { "john.smith@digital.cabinet-office.gov.uk" }
    password { "password with $ymb0l$" }
  end
end
