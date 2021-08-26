class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js { render status: :forbidden }
      format.json { render json: exception.message, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end
end
