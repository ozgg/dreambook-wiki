# frozen_string_literal: true

# Wiki functions for visitors
class WikiController < ApplicationController
  # get /w/
  def index
    @letter = param_from_request(:letter)
    @collection = @letter.blank? ? [] : Pattern.letter(@letter).list_for_visitors
  end

  # get /w/:pattern_slug
  def show
    @entity = Pattern.find_by(slug: params[:slug].downcase)

    handle_http_404('Cannot find pattern') if @entity.nil?
  end
end
