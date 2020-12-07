class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error :not_found, e.message
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render_json_error :unprocessable_entity, e.message
  end

  def render_json_error(status, message)
    render json: { error: message }, status: 500
  end
end
