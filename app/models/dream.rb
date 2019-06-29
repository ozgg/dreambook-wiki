# frozen_string_literal: true

# Dream
#
# Attributes:
#   agent_id [Agent], optional
#   body [text]
#   comments_count [integer]
#   created_at [DateTime]
#   data [jsonb]
#   ip [inet]
#   language_id [Language]
#   personal [boolean]
#   title [string], optional
#   updated_at [DateTime]
#   user_id [User]
#   uuid [uuid]
class Dream < ApplicationRecord
  include Checkable
  include HasOwner

  BODY_LIMIT = 65_535
  NAME_PATTERN = /{(?<name>[^}]{1,30})}(?:\((?<text>[^)]{1,30})\))?/.freeze
  TITLE_LIMIT = 250

  belongs_to :language
  belongs_to :user
  belongs_to :agent, optional: true
  has_many :dream_patterns, dependent: :destroy
  has_many :patterns, through: :dream_patterns
  has_many :dream_words, dependent: :destroy

  after_initialize { self.uuid = SecureRandom.uuid if uuid.nil? }

  validates_presence_of :body
  validates_length_of :body, maximum: BODY_LIMIT
  validates_length_of :title, maximum: TITLE_LIMIT

  scope :recent, -> { order('id desc') }
  scope :generally_accessible, -> { where(personal: false) }
  scope :list_for_visitors, -> { generally_accessible.recent }
  scope :list_for_administration, -> { recent }
  scope :list_for_owner, ->(u) { owned_by(u).recent }

  def self.entity_parameters
    %i[body language_id personal title]
  end

  def title!
    title.blank? ? I18n.t('dreams.untitled') : title
  end

  # @param [User] user
  def editable_by?(user)
    owned_by?(user) || Biovision::Components::DreamComponent.allow?(user)
  end

  # @param [User] user
  def visible_to?(user)
    !personal? || editable_by?(user)
  end
end
