# frozen_string_literal: true

RSpec.describe Binbundle::Jewel do
  subject(:j) do
    described_class.new('searchlink', ['searchlink'], '2.3.66')
  end

  describe '.new' do
    it 'to be a Jewel' do
      expect(j).to be_a(described_class)
    end
  end

  describe '.to_s' do
    it 'output with sudo' do
      j.sudo = true
      j.user_install = false
      expect(j.to_s.scan(/^sudo gem install/).count).to eq 1
    end

    it 'output with user_install' do
      j.sudo = false
      j.user_install = true
      expect(j.to_s.scan(/^gem install --user-install/).count).to eq 1
    end
  end
end
