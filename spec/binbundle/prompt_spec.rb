# frozen_string_literal: true

RSpec.describe Binbundle::Prompt do
  ENV['TESTING'] = 'true'

  subject(:prompt) do
    described_class
  end

  describe '.yn' do
    it 'to respond interpret "yes"' do
      expect(prompt.yn('Do a thing', default_response: 'yes')).to be true
    end

    it 'to interpret a TrueClass' do
      expect(prompt.yn('Do a thing', default_response: true)).to be true
    end

    it 'to interpret "no"' do
      expect(prompt.yn('Do a thing', default_response: 'no')).to be false
    end

    it 'to interpret a FalseClass' do
      expect(prompt.yn('Do a thing', default_response: false)).to be false
    end
  end
end
