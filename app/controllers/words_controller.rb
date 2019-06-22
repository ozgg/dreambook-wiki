# frozen_string_literal: true

# Managing dream words
class WordsController < ApplicationController
  before_action :set_entity, only: %i[edit update destroy]

  # post /words/check
  def check
    @entity = Word.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /words/new
  def new
    @entity = Word.new
  end

  # post /words
  def create
    @entity = Word.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_word_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /words/:id/edit
  def edit
  end

  # patch /words/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_word_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /words/:id
  def destroy
    flash[:notice] = t('words.destroy.success') if @entity.destroy

    redirect_to(admin_words_path)
  end

  protected

  def restrict_access
    component_restriction Biovision::Components::DreambookComponent
  end

  def set_entity
    @entity = Word.find_by(id: params[:id])
    handle_http_404('Cannot find word') if @entity.nil?
  end

  def entity_parameters
    params.require(:word).permit(Word.entity_parameters)
  end
end
