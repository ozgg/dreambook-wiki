# frozen_string_literal: true

# Managing dream words
class Admin::WordsController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: :index

  # get /admin/words
  def index
    @collection = Word.list_for_administration.page(current_page)
  end

  # get /admin/words/:id
  def show
  end

  # put /admin/words/:id/patterns_string
  def patterns_string
    new_string = param_from_request(:string)

    @entity.patterns_string = new_string unless new_string.blank?

    head :no_content
  end

  private

  def restrict_access
    component_restriction Biovision::Components::DreambookComponent
  end

  def set_entity
    @entity = Word.find_by(id: params[:id])
    handle_http_404('Cannot find word') if @entity.nil?
  end
end
