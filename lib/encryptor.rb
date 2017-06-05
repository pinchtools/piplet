class Encryptor

  def initialize
    @crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
  end

  def encrypt(value)
    @crypt.encrypt_and_sign(value)
  end

  def decrypt(value)
    @crypt.decrypt_and_verify(value)
  end

end