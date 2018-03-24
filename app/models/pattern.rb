class Pattern < ApplicationRecord
  include HasOwner

  LINK_PATTERN = /\[\[(?<slug>[^\]]{1,50})\]\](?:\((?<text>[^)]{1,64})\))?/

  TITLE_LIMIT          = 255
  ESSENCE_LIMIT        = 255
  INTERPRETATION_LIMIT = 65535

  belongs_to :language
  belongs_to :user, optional: true
  belongs_to :agent, optional: true
  has_many :pattern_links, dependent: :delete_all
  has_many :pattern_words, dependent: :delete_all
  has_many :words, through: :pattern_words

  before_validation :generate_slug

  validates_presence_of :title, :interpretation
  validates_length_of :title, maximum: TITLE_LIMIT
  validates_length_of :essence, maximum: ESSENCE_LIMIT
  validates_length_of :interpretation, maximum: INTERPRETATION_LIMIT
  validates :slug, uniqueness: { case_sensitive: false, scope: [:language_id] }

  scope :with_slug, -> (slug) { where('lower(slug) = ?', slug.downcase) }
  scope :with_language, -> (language) { where(language: language) }
  scope :approved, -> (flag = true) { where(approved: flag) }
  scope :with_title_like, -> (s) { where('title ilike ?', "%#{s}%") unless s.blank? }
  scope :ordered_by_title, -> { order('title asc') }
  scope :list_for_administration, -> { ordered_by_title }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters
    %i(title essence interpretation)
  end

  # @param [User] user
  def editable_by?(user)
    owned_by?(user) || UserPrivilege.user_has_privilege?(user, :chief_interpreter)
  end

  def approve!
    update!(approved: true)
  end

  private

  def generate_slug
    clean = title.gsub(/[^a-zа-я0-9_,ё\-()]/i, '_')

    self.slug = clean.gsub(/__+/, '_').gsub(/\A_+/, '').gsub(/_+\z/, '')
  end
end
