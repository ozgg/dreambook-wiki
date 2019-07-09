# frozen_string_literal: true

# Managing dream patterns
class Admin::PatternsController < AdminController
  before_action :set_entity, except: :index

  # get /admin/patterns
  def index
    @filter = params[:filter]&.permit!.to_h
    @collection = Pattern.filtered(@filter).list_for_administration.page(current_page)
  end

  # get /admin/patterns/:id
  def show
  end

  # put /admin/patterns/:id/words_string
  def words_string
    new_string = param_from_request(:string)

    @entity.words_string = new_string

    head :no_content
  end

  private

  def restrict_access
    component_restriction Biovision::Components::DreambookComponent
  end

  def set_entity
    @entity = Pattern.find_by(id: params[:id])
    handle_http_404('Cannot find pattern') if @entity.nil?
  end
end
