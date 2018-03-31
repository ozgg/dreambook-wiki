class Word < ApplicationRecord
  BODY_LIMIT = 50

  belongs_to :language
  has_many :pattern_words
  has_many :patterns, through: :pattern_words

  before_validation { self.body = body.downcase unless body.nil? }

  validates_presence_of :body
  validates_uniqueness_of :body, scope: [:language_id]
  validates_length_of :body, maximum: BODY_LIMIT

  scope :list_for_administration, -> { order('body asc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters
    %i(body)
  end
end
