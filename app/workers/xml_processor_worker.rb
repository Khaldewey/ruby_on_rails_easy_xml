require 'nokogiri'

class XmlProcessorWorker
  include Sidekiq::Worker

  def perform(file_path)
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

    # Depuração por logs
    puts "Dados do Documento Fiscal:"
    puts "Número da Série: #{dados_documento[:serie]}"
    puts "Número da Nota Fiscal: #{dados_documento[:nNF]}"
    puts "Data e Hora de Emissão: #{dados_documento[:dhEmi]}"
    puts "Dados do Emitente:"
    puts "  CNPJ: #{dados_documento[:emitente][:CNPJ]}"
    puts "  Nome: #{dados_documento[:emitente][:xNome]}"
    puts "  Fantasia: #{dados_documento[:emitente][:xFant]}"
    puts "  Endereço: #{dados_documento[:emitente][:endereco][:xLgr]}, #{dados_documento[:emitente][:endereco][:nro]} - #{dados_documento[:emitente][:endereco][:xBairro]}, #{dados_documento[:emitente][:endereco][:xMun]}/#{dados_documento[:emitente][:endereco][:UF]}"
    puts "Dados do Destinatário:"
    puts "  CNPJ: #{dados_documento[:destinatario][:CNPJ]}"
    puts "  Nome: #{dados_documento[:destinatario][:xNome]}"
    puts "  Endereço: #{dados_documento[:destinatario][:endereco][:xLgr]}, #{dados_documento[:destinatario][:endereco][:nro]} - #{dados_documento[:destinatario][:endereco][:xBairro]}, #{dados_documento[:destinatario][:endereco][:xMun]}/#{dados_documento[:destinatario][:endereco][:UF]}"    
      
    
  end
end
