# frozen_string_literal: true

# Word
#
# Attributes:
#   body [String]
#   created_at [DateTime]
#   language_id [Language]
#   patterns_count [Integer]
#   processed [Boolean]
#   updated_at [DateTime]
#   weight [Integer]
class Word < ApplicationRecord
  include Checkable
  include Toggleable

  BODY_LIMIT = 150

  toggleable :processed

  belongs_to :language
  has_many :pattern_words, dependent: :destroy
  has_many :patterns, through: :pattern_words
  has_many :dream_words, dependent: :delete_all
  has_many :dreams, through: :dream_words

  before_validation { self.body = body.to_s.downcase }

  validates_uniqueness_of :body, scope: :language_id
  validates_presence_of :body
  validates_length_of :body, maximum: BODY_LIMIT

  scope :ordered_by_weight, -> { order('dreams_count desc') }
  scope :list_for_administration, -> { ordered_by_weight }

  def self.entity_parameters
    %i[body language_id processed]
  end

  def patterns_string
    patterns.pluck(:title).join(', ')
  end

  # @param [String] value
  def patterns_string=(value)
    component = Biovision::Components::DreambookComponent
    value.split(',').reject(&:blank?).map(&:strip).each do |body|
      component.pattern_or_pending(body, language).add_word(self)
    end
  end

  # @param [Pattern] pattern
  def increment_pattern_weights(pattern)
    dream_words.each do |link|
      pattern.link_dream(link.dream, link.weight)
    end
  end
end
