class WordsController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /words/new
  def new
    @entity = Word.new
  end

  # post /words
  def create
    @entity = Word.new(creation_parameters)
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
      flash[:notice] = t('words.update.success')
      form_processed_ok(admin_word_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /words/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('words.destroy.success')
    end
    redirect_to(admin_words_path)
  end

  protected

  def restrict_access
    require_privilege_group :interpreters
  end

  def set_entity
    @entity = Word.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find word')
    end
  end

  def entity_parameters
    params.require(:word).permit(Word.entity_parameters)
  end

  def creation_parameters
    entity_parameters.merge(language: current_language)
  end
end
