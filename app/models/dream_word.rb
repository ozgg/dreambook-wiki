# frozen_string_literal: true

# Occurrence of word in dream
#
# Attributes:
#   dream_id [Dream]
#   weight [Integer]
#   word_id [Word]
class DreamWord < ApplicationRecord
  belongs_to :dream
  belongs_to :word, counter_cache: :dreams_count

  validates_uniqueness_of :word_id, scope: :dream_id

  scope :ordered_by_weight, -> { order('weight desc') }
end
