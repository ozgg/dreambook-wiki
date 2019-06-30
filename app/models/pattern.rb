# frozen_string_literal: true

# Dream pattern
# 
# Attributes:
#   created_at [DateTime]
#   data [jsonb]
#   description [text], optional
#   image [SimpleImageUploader], optional
#   image_alt_text [string], optional
#   language_id [Language]
#   slug [string]
#   summary [string]
#   title [string]
#   updated_at [DateTime]
#   words_count [integer]
class Pattern < ApplicationRecord
  include Checkable

  DESCRIPTION_LIMIT = 65_535
  META_LIMIT = 255
  SUMMARY_LIMIT = 255
  TITLE_LIMIT = 100

  mount_uploader :image, SimpleImageUploader

  belongs_to :language
  has_many :pattern_words, dependent: :destroy
  has_many :words, through: :pattern_words
  has_many :dream_patterns, dependent: :delete_all
  has_many :dreams, through: :dream_patterns

  before_validation { self.slug = title.to_s.downcase }

  validates_uniqueness_of :slug, scope: :language_id
  validates_uniqueness_of :title, scope: :language_id, case_sensitive: false
  validates_presence_of :title, :summary
  validates_length_of :title, maximum: TITLE_LIMIT
  validates_length_of :summary, maximum: SUMMARY_LIMIT
  validates_length_of :description, maximum: DESCRIPTION_LIMIT

  scope :letter, ->(v) { where('title ilike ?', "#{v[0]}%") unless v.blank? }
  scope :with_title, ->(v) { where('lower(title) = lower(?)', v) unless v.blank? }
  scope :ordered_by_title, -> { order('title asc') }
  scope :list_for_visitors, -> { ordered_by_title }
  scope :list_for_administration, -> { ordered_by_title }

  def self.entity_parameters
    %i[description image image_alt_text language_id summary title]
  end

  # @param [Word] entity
  def add_word(entity)
    pattern_words.create(word: entity)
  end

  def words_string
    words.pluck(:body).join(', ')
  end

  # @param [String] value
  def words_string=(value)
    new_ids = []
    value.split(',').reject(&:blank?).map(&:strip).each do |body|
      new_ids << Word.find_or_create_by(body: body, language: language)&.id
    end
    self.word_ids = new_ids.uniq
  end

  # @param [Dream] dream
  # @param [Integer] weight
  def link_dream(dream, weight = 1)
    link = dream_patterns.find_or_initialize_by(dream: dream)
    link.weight = weight
    link.save
  end
end
