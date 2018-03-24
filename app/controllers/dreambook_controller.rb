class DreambookController < ApplicationController
  before_action :set_entity, only: [:show]

  # get /search?q=
  def search
    if params.key?(:q)
      q = param_from_request(:q)

      @results = Pattern.with_language(current_language).with_title_like(q).ordered_by_title.first(10)
    else
      @results = []
    end
  end

  # get /w/:slug
  def show
  end

  private

  def set_entity
    slug = params[:slug] || ''

    @entity = Pattern.with_language(current_language).with_slug(slug).first
    if @entity.nil?
      handle_http_404('Cannot find pattern by slug')
    end
  end
end
