require 'rails_helper'

RSpec.describe Pattern, type: :model do
  let!(:language) { create :language }

  subject { build(:pattern, language: language) }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  it_behaves_like 'requires_language'

  describe 'before validation' do
    it 'generates slug from title' do
      subject.title = "!Проверочный образ/символ Ё-1?;&"
      subject.valid?
      expect(subject.slug).to eq('Проверочный_образ_символ_Ё-1')
    end
  end

  describe 'validation' do
    it 'fails without title' do
      subject.title = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:title)
    end

    it 'fails with too long title' do
      subject.title = 'A' * 256
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:title)
    end

    it 'fails with non-unique slug for the same language' do
      create(:pattern, language: subject.language, title: subject.title + '!')
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'passes with non-unique slug between languages' do
      create(:pattern, title: subject.title)
      expect(subject).to be_valid
    end

    it 'fails with too long essence' do
      subject.essence = 'A' * 256
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:essence)
    end

    it 'fails without interpretation' do
      subject.interpretation = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:interpretation)
    end

    it 'fails with too long interpretation' do
      subject.interpretation = 'A' * 65536
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:interpretation)
    end
  end
end
