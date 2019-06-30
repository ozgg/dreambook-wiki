# frozen_string_literal: true

# Occurrence of word in dream
#
# Attributes:
#   dream_id [Dream]
#   pattern_id [Pattern]
#   weight [Integer]
class DreamPattern < ApplicationRecord
  belongs_to :dream
  belongs_to :pattern, counter_cache: :dreams_count

  validates_uniqueness_of :pattern_id, scope: :dream_id

  scope :ordered_by_weight, -> { order('weight desc') }
end
