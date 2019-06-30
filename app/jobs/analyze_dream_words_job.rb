# frozen_string_literal: true

# Analyze dream words and link patterns
class AnalyzeDreamWordsJob < ApplicationJob
  queue_as :default

  # @param [Integer] dream_id
  def perform(dream_id)
    dream = Dream.find_by(id: dream_id)

    print "\r #{dream.title!}    "

    return if dream.nil?

    handler = DreamHandler.new(dream)
    handler.analyze_words
  end
end
