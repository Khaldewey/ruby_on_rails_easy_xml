require "application_responder"

class Admin::ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  before_action :defaults, :authenticate_user!
  layout 'admin'

  WillPaginate.per_page = 5

  def defaults
    if current_user.present?
     @reports_count = Report.where(user_id: current_user.id).count
    end
  end
end
