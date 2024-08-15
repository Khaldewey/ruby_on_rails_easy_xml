class Admin::ReportsController < Admin::ApplicationController
  def show
    @report = Report.find(params[:id]) 
  end

  def destroy
    Report.find(params[:id]).destroy
    flash[:alert] = "Destroyed Report" 
    redirect_to admin_root_path
  end
end
