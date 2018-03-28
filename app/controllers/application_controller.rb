class ApplicationController < ActionController::Base
  include Biovision::Base::PrivilegeMethods
  protect_from_forgery with: :exception

  def default_url_options
    params.key?(:locale) ? { locale: I18n.locale } : {}
  end
end
