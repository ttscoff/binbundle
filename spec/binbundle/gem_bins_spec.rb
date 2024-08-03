# frozen_string_literal: true

RSpec.describe Binbundle::GemBins do
  subject(:jb) do
    described_class.new(defaults)
  end

  describe '.new' do
    it 'to be a GemBins' do
      expect(jb).to be_a(described_class)
    end
  end

  describe '.bins_to_s' do
    it 'generates correct output' do
      expect(jb.bins_to_s).to match(/\# Executables: /)
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

    it 'fails on local search' do
      options = { gem_for: 'funkle', local: true }

      expect(jb.info(options)).to match(/Gem for funkle not found/)
    end

    it 'fails on missing file' do
      jb.file = 'non_existent.txt'
      options = { gem_for: 'funkle' }
      expect { jb.info(options) }.to raise_error(SystemExit)
    end
  end
end
