# frozen_string_literal: true

# Word for pattern
#
# Attributes:
#   pattern_id [Pattern]
#   word_id [Word]
class PatternWord < ApplicationRecord
  belongs_to :pattern, counter_cache: :words_count
  belongs_to :word, counter_cache: :patterns_count

  validates_uniqueness_of :word_id, scope: :pattern_id
end
