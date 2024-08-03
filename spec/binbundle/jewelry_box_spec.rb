# frozen_string_literal: true

RSpec.describe Binbundle::JewelryBox do
  subject(:jb) do
    described_class.new
  end

  describe '.new' do
    it 'to be a JewelryBox' do
      expect(jb).to be_a(Binbundle::JewelryBox)
    end
  end

  describe '.gem_list' do
    it 'converts gem list to an array of hashes' do
      expect(jb).to be_a(Array)
    end
  end

  describe '.sudo' do
    it 'output all lines with sudo' do
      jb.sudo = true
      jb.user_install = false
      jb.init_from_contents(IO.read('spec/gemlist.txt'))
      expect(jb.to_s.scan(/^sudo gem install/).count).to eq 3
    end
  end

  describe '.user_install' do
    it 'output all lines with --user-install' do
      jb.sudo = false
      jb.user_install = true
      jb.init_from_contents(IO.read('spec/gemlist.txt'))
      expect(jb.to_s.scan(/^gem install --user-install/).count).to eq 3
    end
  end
end
