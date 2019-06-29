# frozen_string_literal: true

# Managing dream dreams
class Admin::DreamsController < AdminController
  before_action :set_entity, except: :index

  # get /admin/dreams
  def index
    @collection = Dream.list_for_administration.page(current_page)
  end

  # get /admin/dreams/:id
  def show
  end

  private

  def restrict_access
    component_restriction Biovision::Components::DreamsComponent
  end

  def set_entity
    @entity = Dream.find_by(id: params[:id])
    handle_http_404('Cannot find dream') if @entity.nil?
  end
end
