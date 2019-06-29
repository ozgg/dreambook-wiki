# frozen_string_literal: true

# Handler for dreams
class DreamHandler
  attr_accessor :dream

  # @param [Dream] dream
  def initialize(dream)
    @dream = dream
  end
end
