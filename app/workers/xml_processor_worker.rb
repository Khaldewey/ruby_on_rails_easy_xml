require 'nokogiri'

class XmlProcessorWorker
  include Sidekiq::Worker

  def perform(file_path, user_id)
    xml_file = File.read(file_path)
    document = Nokogiri::XML(xml_file)
    
    namespace = { 'nfe' => 'http://www.portalfiscal.inf.br/nfe' }

    
    inf_nfe = document.at_xpath('//nfe:infNFe', namespace)
    ide = inf_nfe.at_xpath('nfe:ide', namespace)
    emit = inf_nfe.at_xpath('nfe:emit', namespace)
    dest = inf_nfe.at_xpath('nfe:dest', namespace)
    
    dados_documento = {
      serie: ide.at_xpath('nfe:serie', namespace).text,
      nNF: ide.at_xpath('nfe:nNF', namespace).text,
      dhEmi: ide.at_xpath('nfe:dhEmi', namespace).text,
      emitente: {
        CNPJ: emit.at_xpath('nfe:CNPJ', namespace).text,
        xNome: emit.at_xpath('nfe:xNome', namespace).text,
        xFant: emit.at_xpath('nfe:xFant', namespace).text,
        endereco: {
          xLgr: emit.at_xpath('nfe:enderEmit/nfe:xLgr', namespace).text,
          nro: emit.at_xpath('nfe:enderEmit/nfe:nro', namespace).text,
          xBairro: emit.at_xpath('nfe:enderEmit/nfe:xBairro', namespace).text,
          xMun: emit.at_xpath('nfe:enderEmit/nfe:xMun', namespace).text,
          UF: emit.at_xpath('nfe:enderEmit/nfe:UF', namespace).text
        }
      },
      destinatario: {
        CNPJ: dest.at_xpath('nfe:CNPJ', namespace).text,
        xNome: dest.at_xpath('nfe:xNome', namespace).text,
        endereco: {
          xLgr: dest.at_xpath('nfe:enderDest/nfe:xLgr', namespace).text,
          nro: dest.at_xpath('nfe:enderDest/nfe:nro', namespace).text,
          xBairro: dest.at_xpath('nfe:enderDest/nfe:xBairro', namespace).text,
          xMun: dest.at_xpath('nfe:enderDest/nfe:xMun', namespace).text,
          UF: dest.at_xpath('nfe:enderDest/nfe:UF', namespace).text
        }
      }
    } 

    produtos = []
    totalizadores = {
      vProd: 0,
      vICMS: 0,
      vIPI: 0,
      vPIS: 0,
      vCOFINS: 0
    }

    inf_nfe.xpath('nfe:det', namespace).each do |det|
      prod = det.at_xpath('nfe:prod', namespace)
      imposto = det.at_xpath('nfe:imposto', namespace)
      
      produto_detalhes = {
        nome: prod.at_xpath('nfe:xProd', namespace).text,
        NCM: prod.at_xpath('nfe:NCM', namespace).text,
        CFOP: prod.at_xpath('nfe:CFOP', namespace).text,
        uCom: prod.at_xpath('nfe:uCom', namespace).text,
        qCom: prod.at_xpath('nfe:qCom', namespace).text.to_f,
        vUnCom: prod.at_xpath('nfe:vUnCom', namespace).text.to_f
      }
      
      impostos = {
        vICMS: imposto.at_xpath('nfe:ICMS/nfe:ICMS00/nfe:vICMS', namespace)&.text.to_f,
        vIPI: imposto.at_xpath('nfe:IPI/nfe:IPITrib/nfe:vIPI', namespace)&.text.to_f,
        vPIS: imposto.at_xpath('nfe:PIS/nfe:PISNT/nfe:CST', namespace)&.text.to_f,
        vCOFINS: imposto.at_xpath('nfe:COFINS/nfe:COFINSNT/nfe:CST', namespace)&.text.to_f
      } 


      produtos << { produto: produto_detalhes, impostos: impostos }
      
      totalizadores[:vProd] += produto_detalhes[:qCom] * produto_detalhes[:vUnCom]
      totalizadores[:vICMS] += impostos[:vICMS]
      totalizadores[:vIPI] += impostos[:vIPI]
      totalizadores[:vPIS] += impostos[:vPIS]
      totalizadores[:vCOFINS] += impostos[:vCOFINS]
    end

    
    totalizadores[:vNF] = totalizadores[:vProd] 
 
     
    report = Report.new(
      serie: dados_documento[:serie],
      numero: dados_documento[:nNF],
      data_emissao: dados_documento[:dhEmi],
      cnpj_emitente: dados_documento[:emitente][:CNPJ],
      nome_emitente: dados_documento[:emitente][:xNome],
      fantasia_emitente: dados_documento[:emitente][:xFant],
      endereco_emitente: "#{dados_documento[:emitente][:endereco][:xLgr]}, #{dados_documento[:emitente][:endereco][:nro]} - #{dados_documento[:emitente][:endereco][:xBairro]}, #{dados_documento[:emitente][:endereco][:xMun]}/#{dados_documento[:emitente][:endereco][:UF]}",
      cnpj_destinatario: dados_documento[:destinatario][:CNPJ],
      nome_destinatario: dados_documento[:destinatario][:xNome],
      endereco_destinatario: "#{dados_documento[:destinatario][:endereco][:xLgr]}, #{dados_documento[:destinatario][:endereco][:nro]} - #{dados_documento[:destinatario][:endereco][:xBairro]}, #{dados_documento[:destinatario][:endereco][:xMun]}/#{dados_documento[:destinatario][:endereco][:UF]}",
      valor_total_produtos: totalizadores[:vProd],
      valor_total_icms: totalizadores[:vICMS],
      valor_total_ipi: totalizadores[:vIPI],
      valor_total_pis: totalizadores[:vPIS],
      valor_total_cofins: totalizadores[:vCOFINS],
      valor_total_nota_fiscal: totalizadores[:vNF],
      user_id: user_id,
      products: produtos
    )

    if report.save
      puts "Relatório salvo com sucesso!"
    else
      puts "Erro ao salvar o relatório: #{report.errors.full_messages.join(', ')}"
    end
      
    
  end
end
