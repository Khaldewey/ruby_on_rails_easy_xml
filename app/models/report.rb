class Report < ApplicationRecord
  belongs_to :user
  validates :serie, :numero, :data_emissao, :cnpj_emitente, :nome_emitente, :fantasia_emitente, :endereco_emitente, :cnpj_destinatario, :nome_destinatario, :endereco_destinatario, presence: true
  validates :valor_total_produtos, :valor_total_icms, :valor_total_ipi, :valor_total_pis, :valor_total_cofins, :valor_total_nota_fiscal, numericality: { greater_than_or_equal_to: 0 }

  
end
