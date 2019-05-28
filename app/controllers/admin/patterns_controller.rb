# frozen_string_literal: true

# Managing dream patterns
class Admin::PatternsController < AdminController
  before_action :set_entity, except: :index

  # get /admin/patterns
  def index
    @collection = Pattern.list_for_administration.page(current_page)
  end

  # get /admin/patterns/:id
  def show
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
