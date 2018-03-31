class Admin::PatternsController < AdminController
  include LockableEntity
  include ToggleableEntity
  
  before_action :set_entity, except: [:index]

  # get /admin/patterns
  def index
    @collection = Pattern.page_for_administration(current_page)
  end

  # get /admin/patterns/:id
  def show
  end

  private

  def restrict_access
    require_privilege_group :interpreters
  end

  def set_entity
    @entity = Pattern.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find pattern #{params[:id]}")
    end
  end
end
