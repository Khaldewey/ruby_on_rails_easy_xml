class Admin::ReportsController < Admin::ApplicationController
  def show
    @report = Report.find(params[:id]) 
  end
end
