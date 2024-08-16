class Admin::DocumentsController < Admin::ApplicationController
  def index
    @reports = Report.where(user_id: current_user.id).paginate(page: params[:page], per_page: 5)
    if params[:search].present?
      if params[:search].present?
        search_params = params[:search]
        search_params.each do |key, value|
          case key
          when 'numero'
            @reports = @reports.where(numero: value).paginate(page: params[:page], per_page: 5) if value.present?
          when 'serie'
            @reports = @reports.where(serie: value).paginate(page: params[:page], per_page: 5) if value.present?
          when 'fantasia_emitente'
            @reports = @reports.where(fantasia_emitente: value).paginate(page: params[:page], per_page: 5) if value.present?
          when 'nome_destinatario'
            @reports = @reports.where(nome_destinatario: value).paginate(page: params[:page], per_page: 5) if value.present?
          when 'cnpj_emitente'
            @reports = @reports.where(cnpj_emitente: value).paginate(page: params[:page], per_page: 5) if value.present?
          when 'cnpj_destinatario'
            @reports = @reports.where(cnpj_destinatario: value).paginate(page: params[:page], per_page: 5) if value.present?
          end
        end
      end
    end
  end 



  def upload
    if params[:file].present?
      uploaded_file = params[:file] 
      if uploaded_file.content_type == "text/xml"
        file_path = Rails.root.join('tmp', uploaded_file.original_filename)
        File.open(file_path, 'wb') { |file| file.write(uploaded_file.read) }
        XmlProcessorWorker.perform_async(file_path, current_user.id)
        flash[:notice] = "XML file sent successfully! Processing will be done in the background."
      else
        flash[:alert] = "Please submit a valid XML file."
      end  
      redirect_to admin_root_path(flag: true)
    else 
     flash[:alert] = "Forbidden empty field."
     redirect_to admin_root_path
    end
  end 

  

end
