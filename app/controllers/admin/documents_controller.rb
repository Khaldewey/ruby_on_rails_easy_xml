class Admin::DocumentsController < Admin::ApplicationController
  def index
    
  end 

  def upload
    uploaded_file = params[:file]
    if uploaded_file.content_type == "text/xml"
      file_path = Rails.root.join('tmp', uploaded_file.original_filename)
      File.open(file_path, 'wb') { |file| file.write(uploaded_file.read) }
      XmlProcessorWorker.perform_async(file_path)
      flash[:notice] = "XML file sent successfully! Processing will be done in the background."
    else
      flash[:alert] = "Please submit a valid XML file."
    end
    
    redirect_to admin_root_path
  end 

  

end
