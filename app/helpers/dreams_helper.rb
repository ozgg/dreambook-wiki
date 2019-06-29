# frozen_string_literal: true

# Helper methods for handling dreams
module DreamsHelper
  # @param [Dream] entity
  # @param [String] text
  # @param [Hash] options
  def admin_dream_link(entity, text = entity.title!, options = {})
    link_to(text, admin_dream_path(id: entity.id), options)
  end

  # @param [Dream] entity
  # @param [String] text
  # @param [Hash] options
  def my_dream_link(entity, text = entity.title!, options = {})
    link_to(text, my_dream_path(id: entity.id), options)
  end

  # @param [Dream] entity
  # @param [String] text
  # @param [Hash] options
  def dream_link(entity, text = entity.title!, options = {})
    link_to(text, dream_path(id: entity.id), options)
  end
end
