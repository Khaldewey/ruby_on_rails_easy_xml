require 'rails_helper'

RSpec.describe User, type: :model do
  it 'é válido com atributos válidos'do
    user = User.new(email:'testezinho@exemplo.com', password:'senha123')
    expect(user).to be_valid
  end

  it 'não é válido sem um email'do
    user = User.new(email:nil, password:'senha123')
    expect(user).to_not be_valid
  end

  it 'não é válido sem uma senha'do
    user = User.new(email:'teste@exemplo.com', password:nil)
    expect(user).to_not be_valid
  end 

  it 'requer um email único'do 
    User.create(email:'unico@exemplo.com', password:'senha123')
    usuario_duplicado = User.new(email:'unico@exemplo.com', password:'senha123')
    expect(usuario_duplicado).to_not be_valid
    expect(usuario_duplicado.errors[:email]).to include('has already been taken')
  end

  it 'requer uma senha com comprimento mínimo'do
    user = User.new(email:'teste@exemplo.com', password:'curta')
    expect(user).to_not be_valid
    expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
  end 

  it 'autentica com uma senha válida'do
    user = User.create(email:'teste@exemplo.com', password:'senha123')
    expect(user.valid_password?('senha123')).to be_truthy
  end

  it 'não autentica com uma senha inválida'do
    user = User.create(email:'teste@exemplo.com', password:'senha123')
    expect(user.valid_password?('senhaincorreta')).to be_falsey
  end  

 

end
