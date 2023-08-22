Rails.application.routes.draw do
  devise_for :users

  root "root#index"

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response
end
