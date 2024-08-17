require'rails_helper'
require'sidekiq/testing'
Sidekiq::Testing.inline!

RSpec.describe XmlProcessorWorker, type: :worker do
  describe 'perform' do
    let(:user) { User.create(id:2, email:'test@example.com', password:'123456789') }
    let(:file_path) { 'spec/fixtures/files/sample.xml' }

    before do
      File.write(file_path,<<-XML
        <nfeProc xmlns="http://www.portalfiscal.inf.br/nfe">
          <NFe>
            <infNFe>
              <ide>
                <serie>1</serie>
                <nNF>12345</nNF>
                <dhEmi>2024-08-16T10:00:00</dhEmi>
              </ide>
              <emit>
                <CNPJ>12345678000195</CNPJ>
                <xNome>Empresa Emitente</xNome>
                <xFant>Fantasia Emitente</xFant>
                <enderEmit>
                  <xLgr>Rua A</xLgr>
                  <nro>123</nro>
                  <xBairro>Centro</xBairro>
                  <xMun>Cidade</xMun>
                  <UF>SP</UF>
                </enderEmit>
              </emit>
              <dest>
                <CNPJ>98765432000196</CNPJ>
                <xNome>Empresa Destinatária</xNome>
                <enderDest>
                  <xLgr>Rua B</xLgr>
                  <nro>456</nro>
                  <xBairro>Bairro</xBairro>
                  <xMun>Outra Cidade</xMun>
                  <UF>RJ</UF>
                </enderDest>
              </dest>
              <det>
                <prod>
                  <xProd>Produto 1</xProd>
                  <NCM>12345678</NCM>
                  <CFOP>5102</CFOP>
                  <uCom>UN</uCom>
                  <qCom>10</qCom>
                  <vUnCom>100.00</vUnCom>
                </prod>
                <imposto>
                  <ICMS>
                    <ICMS00>
                      <vICMS>18.00</vICMS>
                    </ICMS00>
                  </ICMS>
                  <IPI>
                    <IPITrib>
                      <vIPI>5.00</vIPI>
                    </IPITrib>
                  </IPI>
                  <PIS>
                    <PISNT>
                      <CST>07</CST>
                    </PISNT>
                  </PIS>
                  <COFINS>
                    <COFINSNT>
                      <CST>07</CST>
                    </COFINSNT>
                  </COFINS>
                </imposto>
              </det>
            </infNFe>
          </NFe>
        </nfeProc>
      XML
      )
    end
    
    after do
      File.delete(file_path) if File.exist?(file_path)
    end

    it 'processa o XML corretamente e salva o relatório no banco de dados'do
      expect {
        XmlProcessorWorker.new.perform(file_path, user.id)
      }.to change { Report.count }.by(1)

      report = Report.last
      expect(report.serie).to eq('1')
      expect(report.numero).to eq('12345')
      expect(report.cnpj_emitente).to eq('12345678000195')
      expect(report.nome_emitente).to eq('Empresa Emitente')
      expect(report.fantasia_emitente).to eq('Fantasia Emitente')
      expect(report.endereco_emitente).to eq('Rua A, 123 - Centro, Cidade/SP')
      expect(report.cnpj_destinatario).to eq('98765432000196')
      expect(report.nome_destinatario).to eq('Empresa Destinatária')
      expect(report.endereco_destinatario).to eq('Rua B, 456 - Bairro, Outra Cidade/RJ')
      expect(report.valor_total_produtos).to eq(1000.00)
      expect(report.valor_total_icms).to eq(18.00)
      expect(report.valor_total_ipi).to eq(5.00)
      expect(report.valor_total_pis).to eq(7.0)
      expect(report.valor_total_cofins).to eq(7.0)
      expect(report.valor_total_nota_fiscal).to eq(1000.00)

      expect(report.products.size).to eq(1)
      expect(report.products.first["produto"]["nome"]).to eq('Produto 1')
    end

    it 'exibe uma mensagem de erro caso o relatório não seja salvo corretamente'do
      allow_any_instance_of(Report).to receive(:save).and_return(false)
      expect {
        XmlProcessorWorker.new.perform(file_path, user.id)
      }.to output(/Erro ao salvar o relatório/).to_stdout
    end
    
  end
end