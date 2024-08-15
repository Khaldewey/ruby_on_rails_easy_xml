class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :serie
      t.string :numero
      t.datetime :data_emissao
      t.string :cnpj_emitente
      t.string :nome_emitente
      t.string :fantasia_emitente
      t.string :endereco_emitente
      t.string :cnpj_destinatario
      t.string :nome_destinatario
      t.string :endereco_destinatario
      t.decimal :valor_total_produtos, precision: 15, scale: 2
      t.decimal :valor_total_icms, precision: 15, scale: 2
      t.decimal :valor_total_ipi, precision: 15, scale: 2
      t.decimal :valor_total_pis, precision: 15, scale: 2
      t.decimal :valor_total_cofins, precision: 15, scale: 2
      t.decimal :valor_total_nota_fiscal, precision: 15, scale: 2
      t.jsonb :products, default: {}
      t.timestamps
    end
  end
end
