class RootController < ApplicationController
  before_action :redirect_if_user_not_signed_in

  def index
  end

private

  def redirect_if_user_not_signed_in
    redirect_to new_user_session_path unless current_user
  end
end
