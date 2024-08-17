require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'validações de presença'do
    it 'é inválido sem a série'do
      report = Report.new(serie:nil)
      report.valid?
      expect(report.errors[:serie]).to include("can't be blank")
    end
  end
  it 'é inválido sem o número'do
    report = Report.new(numero:nil)
    report.valid?
    expect(report.errors[:numero]).to include("can't be blank")
  end

  it 'é inválido sem a data de emissão'do
    report = Report.new(data_emissao:nil)
    report.valid?
    expect(report.errors[:data_emissao]).to include("can't be blank")
  end

  it 'é inválido sem o CNPJ do emitente'do
    report = Report.new(cnpj_emitente:nil)
    report.valid?
    expect(report.errors[:cnpj_emitente]).to include("can't be blank")
  end

  it 'é inválido sem o nome do emitente'do
    report = Report.new(nome_emitente:nil)
    report.valid?
    expect(report.errors[:nome_emitente]).to include("can't be blank")
  end

  it 'é inválido sem a fantasia do emitente'do
    report = Report.new(fantasia_emitente:nil)
    report.valid?
    expect(report.errors[:fantasia_emitente]).to include("can't be blank")
  end

  it 'é inválido sem o endereço do emitente'do
    report = Report.new(endereco_emitente:nil)
    report.valid?
    expect(report.errors[:endereco_emitente]).to include("can't be blank")
  end

  it 'é inválido sem o CNPJ do destinatário'do
    report = Report.new(cnpj_destinatario:nil)
    report.valid?
    expect(report.errors[:cnpj_destinatario]).to include("can't be blank")
  end

  it 'é inválido sem o nome do destinatário'do
    report = Report.new(nome_destinatario:nil)
    report.valid?
    expect(report.errors[:nome_destinatario]).to include("can't be blank")
  end

  it 'é inválido sem o endereço do destinatário'do
    report = Report.new(endereco_destinatario:nil)
    report.valid?
    expect(report.errors[:endereco_destinatario]).to include("can't be blank")
  end


 describe 'validações de valores numéricos'do
    it 'é inválido se o valor total dos produtos for menor que 0'do
      report = Report.new(valor_total_produtos: -1)
      report.valid?
      expect(report.errors[:valor_total_produtos]).to include('must be greater than or equal to 0')
    end 
 end

  it 'é inválido se o valor total do ICMS for menor que 0'do
    report = Report.new(valor_total_icms: -1)
    report.valid?
    expect(report.errors[:valor_total_icms]).to include('must be greater than or equal to 0')
  end

  it 'é inválido se o valor total do IPI for menor que 0'do
    report = Report.new(valor_total_ipi: -1)
    report.valid?
    expect(report.errors[:valor_total_ipi]).to include('must be greater than or equal to 0')
  end

  it 'é inválido se o valor total do PIS for menor que 0'do
    report = Report.new(valor_total_pis: -1)
    report.valid?
    expect(report.errors[:valor_total_pis]).to include('must be greater than or equal to 0')
  end

  it 'é inválido se o valor total do COFINS for menor que 0'do
    report = Report.new(valor_total_cofins: -1)
    report.valid?
    expect(report.errors[:valor_total_cofins]).to include('must be greater than or equal to 0')
  end

  it 'é inválido se o valor total da nota fiscal for menor que 0'do
    report = Report.new(valor_total_nota_fiscal: -1)
    report.valid?
    expect(report.errors[:valor_total_nota_fiscal]).to include('must be greater than or equal to 0')
  end


  describe 'associação com o modelo User'do
    it 'pertence a um usuário'do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
      end
    end
  

end
