class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :api_url

  protected

  def verify_bot_authorized
    @bot = AuthorizedBot.find_by_key(params[:authorization])
    return if @bot.present?

    render(plain: 'YOU SHALL NOT PASS!', status: 403)
  end

  def verify_admin
    raise ActionController::RoutingError, 'Not Found' unless current_user.has_role?(:admin)
  end

  def api_url(path, user = nil, params = {})
    url = "https://api.stackexchange.com/2.2#{path}?key=#{AppConfig['se_api_key']}"
    url += "&access_token=#{user.stack_user.access_token}" if user&.stack_user

    params.each do |key, val|
      url += "&#{key}=#{val}"
    end

    url
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
