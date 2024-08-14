class Admin::DocumentsController < Admin::ApplicationController
  def index
    
  end 

  def upload
    uploaded_file = params[:file]

    if uploaded_file.content_type == "application/xml"
      xml_content = uploaded_file.read
      flash[:success] = "Arquivo XML enviado e processado com sucesso!"
    else
      flash[:error] = "Por favor, envie um arquivo XML válido."
    end
    redirect_to upload_documents_path
  end

end
