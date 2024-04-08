require 'rails_helper'

describe Encryption::AesCipher do
  let(:plaintext) { 'some long secret' }
  let(:cek) { SecureRandom.random_bytes(32) }

  describe '#encrypt' do
    it 'returns JSON string containing AES-encrypted ciphertext' do
      ciphertext = subject.encrypt(plaintext, cek)

      expect(ciphertext).to_not match plaintext
      expect(ciphertext).to be_a String
      expect { JSON.parse(ciphertext) }.to_not raise_error
    end
  end

  describe '#decrypt' do
    it 'returns plaintext' do
      ciphertext = subject.encrypt(plaintext, cek)

      expect(subject.decrypt(ciphertext, cek)).to eq plaintext
    end

    it 'raises error on invalid input' do
      ciphertext = subject.encrypt(plaintext, cek)
      ciphertext += 'foo'

      expect { subject.decrypt(ciphertext, cek) }.to raise_error Encryption::EncryptionError
    end
  end
end
