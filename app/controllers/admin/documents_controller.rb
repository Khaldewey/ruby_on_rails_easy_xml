class Admin::DocumentsController < Admin::ApplicationController
  require 'rubyXL'
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
    elsif params[:zip].present?
      file = params[:zip]
      Dir.mktmpdir do |dir|
        Zip::File.open(file.path) do |zip_file|
          zip_file.each do |entry|
            next unless entry.name.end_with?('.xml')
            extracted_file_path = Rails.root.join('tmp', entry.name)
            entry.extract(extracted_file_path) { true } 
            XmlProcessorWorker.perform_async(extracted_file_path.to_s, current_user.id)
          end 
        end
      end  
      flash[:notice] = "File sent successfully! Processing will be done in the background."
      redirect_to admin_root_path(flag: true)
    else
     flash[:alert] = "Forbidden empty field."
     redirect_to admin_root_path
    end 

    

  end 

  def download_xls
    @report = Report.find(params[:id])
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]

  
    worksheet.add_cell(0, 0, 'Dados do Documento Fiscal')
    worksheet.add_cell(1, 0, 'Número da Série')
    worksheet.add_cell(1, 1, @report.serie)
    worksheet.add_cell(2, 0, 'Número da Nota Fiscal')
    worksheet.add_cell(2, 1, @report.numero)
    worksheet.add_cell(3, 0, 'Data e Hora de Emissão')
    worksheet.add_cell(3, 1, @report.data_emissao.strftime("%d/%m/%Y %H:%M"))

  
    worksheet.add_cell(5, 0, 'Dados do Emitente')
    worksheet.add_cell(6, 0, 'CNPJ')
    worksheet.add_cell(6, 1, @report.cnpj_emitente)
    worksheet.add_cell(7, 0, 'Nome')
    worksheet.add_cell(7, 1, @report.nome_emitente)
    worksheet.add_cell(8, 0, 'Fantasia')
    worksheet.add_cell(8, 1, @report.fantasia_emitente)
    worksheet.add_cell(9, 0, 'Endereço')
    worksheet.add_cell(9, 1, @report.endereco_emitente)

    
    worksheet.add_cell(11, 0, 'Dados do Destinatário')
    worksheet.add_cell(12, 0, 'CNPJ')
    worksheet.add_cell(12, 1, @report.cnpj_destinatario)
    worksheet.add_cell(13, 0, 'Nome')
    worksheet.add_cell(13, 1, @report.nome_destinatario)
    worksheet.add_cell(14, 0, 'Endereço')
    worksheet.add_cell(14, 1, @report.endereco_destinatario)

 
    worksheet.add_cell(16, 0, 'Produtos')
    @report.products.each_with_index do |produto, index|
      base_row = 17 + (index * 9) 
      worksheet.add_cell(base_row, 0, "Produto #{index + 1}:")
      worksheet.add_cell(base_row + 1, 0, 'Nome')
      worksheet.add_cell(base_row + 1, 1, produto["produto"]["nome"])
      worksheet.add_cell(base_row + 2, 0, 'NCM')
      worksheet.add_cell(base_row + 2, 1, produto["produto"]["NCM"])
      worksheet.add_cell(base_row + 3, 0, 'CFOP')
      worksheet.add_cell(base_row + 3, 1, produto["produto"]["CFOP"])
      worksheet.add_cell(base_row + 4, 0, 'Unidade Comercializada')
      worksheet.add_cell(base_row + 4, 1, produto["produto"]["uCom"])
      worksheet.add_cell(base_row + 5, 0, 'Quantidade Comercializada')
      worksheet.add_cell(base_row + 5, 1, produto["produto"]["qCom"].to_s)
      worksheet.add_cell(base_row + 6, 0, 'Valor Unitário')
      worksheet.add_cell(base_row + 6, 1, produto["produto"]["vUnCom"].to_s)
      worksheet.add_cell(base_row + 7, 0, 'ICMS')
      worksheet.add_cell(base_row + 7, 1, produto["impostos"]["vICMS"].to_s)
      worksheet.add_cell(base_row + 8, 0, 'IPI')
      worksheet.add_cell(base_row + 8, 1, produto["impostos"]["vIPI"].to_s)
      worksheet.add_cell(base_row + 9, 0, 'PIS')
      worksheet.add_cell(base_row + 9, 1, produto["impostos"]["vPIS"].to_s)
      worksheet.add_cell(base_row + 10, 0, 'COFINS')
      worksheet.add_cell(base_row + 10, 1, produto["impostos"]["vCOFINS"].to_s)
    end

    
    totalizadores_row = 17 + (@report.products.size * 9) + 2
    worksheet.add_cell(totalizadores_row, 0, 'Totalizadores')
    worksheet.add_cell(totalizadores_row + 1, 0, 'Valor Total dos Produtos')
    worksheet.add_cell(totalizadores_row + 1, 1, "R$ #{@report.valor_total_produtos}")
    worksheet.add_cell(totalizadores_row + 2, 0, 'Valor Total do ICMS')
    worksheet.add_cell(totalizadores_row + 2, 1, "R$ #{@report.valor_total_icms}")
    worksheet.add_cell(totalizadores_row + 3, 0, 'Valor Total do IPI')
    worksheet.add_cell(totalizadores_row + 3, 1, "R$ #{@report.valor_total_ipi}")
    worksheet.add_cell(totalizadores_row + 4, 0, 'Valor Total do PIS')
    worksheet.add_cell(totalizadores_row + 4, 1, "R$ #{@report.valor_total_pis}")
    worksheet.add_cell(totalizadores_row + 5, 0, 'Valor Total do COFINS')
    worksheet.add_cell(totalizadores_row + 5, 1, "R$ #{@report.valor_total_cofins}")
    worksheet.add_cell(totalizadores_row + 6, 0, 'Valor Total da Nota Fiscal')
    worksheet.add_cell(totalizadores_row + 6, 1, "R$ #{@report.valor_total_nota_fiscal}")

    
    temp_file = Tempfile.new(['relatorio', '.xlsx'])
    workbook.write(temp_file.path)

    
    send_file temp_file.path, filename: "nfe_numero_#{@report.numero}.xlsx", type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end 

  def export_excel
    @reports = Report.order(params[:sort])

    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = 'Relatórios'
    
    headers = ['Número', 'Série', 'Emitente', 'Destinatário', 'CNPJ Emitente', 'CNPJ Destinatário']
    headers.each_with_index do |header, index|
      worksheet.add_cell(0, index, header)
    end
  
    @reports.each_with_index do |report, index|
      worksheet.add_cell(index + 1, 0, report.numero)
      worksheet.add_cell(index + 1, 1, report.serie)
      worksheet.add_cell(index + 1, 2, report.fantasia_emitente)
      worksheet.add_cell(index + 1, 3, report.nome_destinatario)
      worksheet.add_cell(index + 1, 4, report.cnpj_emitente)
      worksheet.add_cell(index + 1, 5, report.cnpj_destinatario)
    end

    temp_file = Tempfile.new(['relatorios', '.xlsx'])
    workbook.write(temp_file.path)
    send_file temp_file.path, filename: "relatorios_#{Date.today}.xlsx", type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end
  

end
