Rails.application.routes.draw do
  devise_for :users

  root "root#index"

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response

  resource :line_reports, only: [:show]
  resource :annual_leave_requests, only: [:new]

  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?
end
