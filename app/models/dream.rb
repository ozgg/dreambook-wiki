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

  belongs_to :language
  belongs_to :user
  belongs_to :agent, optional: true
  has_many :dream_patterns, dependent: :destroy
  has_many :patterns, through: :dream_patterns
  has_many :dream_words, dependent: :destroy
end
