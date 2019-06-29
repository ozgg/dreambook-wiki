# frozen_string_literal: true

# Managing dreams
class DreamsController < ApplicationController
  before_action :restrict_anonymous_access, only: %i[new create]
  before_action :set_entity, only: %i[show edit update destroy]
  before_action :restrict_editing, only: %i[edit update destroy]

  # post /dreams/check
  def check
    @entity = Dream.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /dreams
  def index
    @collection = Dream.list_for_visitors.page(current_page)
  end

  # get /dreams/new
  def new
    @entity = Dream.new
  end

  # post /dreams
  def create
    @entity = Dream.new(creation_parameters)
    if @entity.save
      form_processed_ok(dream_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /dreams/:id/edit
  def edit
  end

  # patch /dreams/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(dream_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /dreams/:id
  def destroy
    flash[:notice] = t('dreams.destroy.success') if @entity.destroy

    redirect_to(dreams_path)
  end

  protected

  def restrict_editing
    handle_http_403('Cannot edit dream') unless @entity.editably_by?(current_user)
  end

  def set_entity
    @entity = Dream.find_by(id: params[:id])
    handle_http_404('Cannot find dream') if @entity.nil?
  end

  def entity_parameters
    params.require(:dream).permit(Dream.entity_parameters)
  end

  def creation_parameters
    addition = { language: current_language }.merge(owner_for_entity(true))
    entity_parameters.merge(addition)
  end
end
