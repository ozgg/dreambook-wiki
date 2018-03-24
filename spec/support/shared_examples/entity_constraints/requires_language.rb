require 'rails_helper'

RSpec.shared_examples_for 'requires_language' do
  describe 'validation' do
    it 'fails without language' do
      subject.language = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:language)
    end
  end
end
