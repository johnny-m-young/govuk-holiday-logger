FactoryBot.define do
  factory(:user) do
    given_name { "John" }
    family_name { "Smith" }
    sequence(:email) { |n| "user-#{n}@digital.cabinet-office.gov.uk" }
    password { "password with $ymb0l$" }
    annual_leave_remaining { 27.5 }
  end

  trait(:line_manager) do
    after(:create) do |line_manager|
      3.times do |n|
        create(:user, given_name: "LineReport", family_name: n.to_s, line_manager_id: line_manager.id)
      end
    end
  end
end
