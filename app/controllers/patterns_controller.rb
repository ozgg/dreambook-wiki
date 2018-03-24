class PatternsController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /patterns/new
  def new
    @entity = Pattern.new
  end

  # post /patterns
  def create
    @entity = Pattern.new(creation_parameters)
    if @entity.save
      form_processed_ok(admin_pattern_path(@entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /patterns/:id/edit
  def edit
  end

  # patch /patterns/:id
  def update
    if @entity.update(entity_parameters)
      flash[:notice] = t('patterns.update.success')
      form_processed_ok(admin_pattern_path(@entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /patterns/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('patterns.destroy.success')
    end
    redirect_to(admin_patterns_path)
  end

  protected

  def restrict_access
    require_privilege_group :interpreters
  end

  def set_entity
    @entity = Pattern.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find pattern')
    end
  end

  def entity_parameters
    params.require(:pattern).permit(Pattern.entity_parameters)
  end

  def creation_parameters
    parameters = params.require(:pattern).permit(Pattern.creation_parameters)
    parameters.merge!(owner_for_entity(true))
    parameters.merge(language: current_language)
  end
end
