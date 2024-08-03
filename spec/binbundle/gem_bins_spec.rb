# frozen_string_literal: true

RSpec.describe Binbundle::GemBins do
  subject(:jb) do
    described_class.new(defaults)
  end

  describe '.new' do
    it 'to be a GemBins' do
      expect(jb).to be_a(Binbundle::GemBins)
    end
  end

  describe '.info' do
    it 'gets the binary for gem' do
      options = { bin_for: 'searchlink' }
      expect(jb.info(options)).to match(/funkle/)
    end

    it 'gets the gem for binary' do
      options = { gem_for: 'funkle' }
      expect(jb.info(options)).to eq 'searchlink'
    end
  end
end
