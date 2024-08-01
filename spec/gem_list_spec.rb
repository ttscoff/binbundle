# frozen_string_literal: true

RSpec.describe Binbundle::GemList do
  subject(:gb) do
    Binbundle::GemList.new(IO.read('spec/gemlist.txt'))
  end

  describe '.gem_list' do
    it 'converts gem list to an array of hashes' do
      expect(gb.gem_list).to be_a(Array)
    end
  end

  describe '.sudo' do
    it 'output all lines with sudo' do
      expect(gb.sudo.join("\n").scan(/^sudo gem install/).count).to eq 3
    end
  end

  describe '.user_install' do
    it 'output all lines with --user-install' do
      expect(gb.user_install.join("\n").scan(/^gem install --user-install/).count).to eq 3
    end
  end
end
