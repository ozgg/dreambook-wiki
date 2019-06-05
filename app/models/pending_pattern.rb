# frozen_string_literal: true

# Pending pattern for interpretation
#
# Attributes:
#   created_at [DateTime]
#   language_id [Language]
#   name [String]
#   pattern_id [Pattern]
#   processed [Boolean]
#   updated_at [DateTime]
class PendingPattern < ApplicationRecord
  NAME_LIMIT = 100

  belongs_to :pattern, optional: true
  belongs_to :language

  validates_presence_of :name
  validates_length_of :name, maximum: NAME_LIMIT
  validates_uniqueness_of :name, scope: :language_id, case_sensitive: false

  scope :processed, ->(v = true) { where(processed: [true, false].include?(v) ? v : v.to_i.positive?) unless v.to_s.blank? }
  scope :list_for_administration, -> { order('processed asc, name asc') }
  scope :filtered, ->(f) { processed(f[:processed]) }

  # @param [Integer] page
  # @param [Hash] filter
  def self.page_for_administration(page = 1, filter = {})
    filtered(filter).list_for_administration.page(page)
  end

  # @param [String] summary
  def process!(summary)
    pattern = Pattern.new(language: language, title: name, summary: summary)
    update(pattern: pattern, processed: true) if pattern.save
  end

  # @param [Array<String>] list
  # @param [Language] language
  def self.enqueue(list, language)
    precondition = Pattern.where(language: language)
    list.each do |name|
      pattern = precondition.find_by('lower(title) = lower(?)', name)
      create(
        language: language,
        name: name.downcase,
        pattern: pattern,
        processed: !pattern.nil?
      )
    end
  end
end
