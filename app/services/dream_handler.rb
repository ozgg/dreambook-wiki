# frozen_string_literal: true

# Handler for dreams
class DreamHandler
  EXCLUSION_PATTERN = /[^-a-zA-Z0-9а-яёА-ЯЁ]/.freeze

  attr_accessor :dream

  # @param [Dream] dream
  def initialize(dream)
    @dream = dream
  end

  def analyze_words
    chunks = @dream.body.gsub(EXCLUSION_PATTERN, ' ').split(/\s+/)
    chunks.each(&method(:process_word))
    link_patterns
  end

  private

  # @param [String] string
  def process_word(string)
    return if string.blank?

    criteria = { body: string.strip.downcase, language: @dream.language }
    link_word(Word.find_or_create_by(criteria))
  end

  # @param [Word] word
  def link_word(word)
    link = DreamWord.find_or_initialize_by(word: word, dream: @dream)
    link.increment :weight unless link.id.nil?
    link.save!
  end

  def link_patterns
    @dream.dream_patterns.destroy_all
    buffer = {}
    @dream.dream_words.each do |dream_word|
      dream_word.word.patterns.each do |pattern|
        buffer[pattern] = 0 unless buffer.key?(pattern)
        buffer[pattern] += dream_word.weight
      end
    end
    buffer.each(&method(:link_pattern))
  end

  # @param [Pattern] pattern
  # @param [Integer] weight
  def link_pattern(pattern, weight)
    DreamPattern.create(dream: @dream, pattern: pattern, weight: weight)
  end
end
