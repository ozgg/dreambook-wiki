# frozen_string_literal: true

module Biovision
  module Components
    # Dreambook component
    class DreambookComponent < BaseComponent
      # @param [String] body
      # @param [Language] language
      # @return [Pattern|PendingPattern]
      def self.pattern_or_pending(body, language)
        pattern = Pattern.find_by(title: body, language: language)

        return pattern unless pattern.nil?

        PendingPattern.find_or_create_by(name: body, language: language)
      end
    end
  end
end
