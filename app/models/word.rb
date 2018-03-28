class Word < ApplicationRecord
  BODY_LIMIT = 50

  belongs_to :language

  before_validation { self.body = body.downcase unless body.nil? }

  validates_presence_of :body
  validates_uniqueness_of :body, scope: [:language_id]
  validates_length_of :body, maximum: BODY_LIMIT
end
