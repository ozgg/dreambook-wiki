# frozen_string_literal: true

# Helper methods for handling dreambook
module DreambookHelper
  # @param [Pattern] entity
  # @param [String] text
  # @param [Hash] options
  def admin_pattern_link(entity, text = entity.title, options = {})
    link_to(text, admin_pattern_path(id: entity.id), options)
  end

  # @param [Word] entity
  # @param [String] text
  # @param [Hash] options
  def admin_word_link(entity, text = entity.body, options = {})
    link_to(text, admin_word_path(id: entity.id), options)
  end
end
