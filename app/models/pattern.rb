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

  before_validation { self.slug = title.to_s.downcase }

  validates_uniqueness_of :slug, scope: :language_id
  validates_presence_of :title, :summary
  validates_length_of :title, maximum: TITLE_LIMIT
  validates_length_of :summary, maximum: SUMMARY_LIMIT
  validates_length_of :description, maximum: DESCRIPTION_LIMIT

  scope :letter, ->(v) { where('title ilike ?', "#{v[0]}%") unless v.blank? }
  scope :ordered_by_title, -> { order('title asc') }
  scope :list_for_visitors, -> { ordered_by_title }
  scope :list_for_administration, -> { ordered_by_title }

  def self.entity_parameters
    %i[description image image_alt_text language_id summary title]
  end
end
