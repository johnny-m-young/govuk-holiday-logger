Rails.application.routes.draw do
  devise_for :users

  root "root#index"

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response

  resources :line_reports, only: %i[index show]
  resources :annual_leave_requests, only: %i[new create] do
    get "approve"
    patch "update_status"
    get "deny"
  end
  get "/annual_leave_requests/check", to: "annual_leave_requests#check", as: "check_annual_leave_request"
  get "/annual_leave_requests/confirmation", to: "annual_leave_requests#confirm", as: "annual_leave_request_confirmation"
  get "/annual_leave_requests/approval_confirmation", to: "annual_leave_requests#confirm_approval", as: "confirm_annual_leave_request_approval"

  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?
end
