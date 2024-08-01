# frozen_string_literal: true

RSpec.describe ::String do
  describe '.gem_list' do
    it 'converts gem list to an array of hashes' do
      list = IO.read('spec/gemlist.txt')
      expect(list.gem_list).to be_a(Array)
    end
  end

  describe '.sudo' do
    it 'output all lines with sudo' do
      list = IO.read('spec/gemlist.txt')
      expect(list.sudo.join("\n").scan(/^sudo gem install/).count).to eq 3
    end
  end

  describe '.user_install' do
    it 'output all lines with --user-install' do
      list = IO.read('spec/gemlist.txt')
      expect(list.user_install.join("\n").scan(/^gem install --user-install/).count).to eq 3
    end
  end
end
