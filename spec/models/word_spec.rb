require 'rails_helper'

RSpec.describe Word, type: :model do
  let!(:language) { create :language }

  subject { build(:word, language: language) }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  it_behaves_like 'requires_language'

  describe 'before validation' do
    it 'converts body to lowercase' do
      subject.body = 'ПРОВЕРКА'
      subject.valid?
      expect(subject.body).to eq('проверка')
    end
  end

  describe 'validation' do
    it 'fails without body' do
      subject.body = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end

    it 'fails with too long body' do
      subject.body = 'A' * 51
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end

    it 'fails with non-unique body for same language' do
      create :word, language: subject.language, body: subject.body
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end

    it 'passes with non-unique body for different language' do
      create :word, body: subject.body
      expect(subject).to be_valid
    end
  end
end
