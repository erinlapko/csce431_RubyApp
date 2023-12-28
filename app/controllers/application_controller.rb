class ApplicationController < ActionController::Base
    include Pundit::Authorization
    before_action :authenticate_admin!
    add_flash_types :info, :error, :success
end
