class Admin::WordsController < AdminController
  before_action :set_entity, except: [:index]

  # get /admin/words
  def index
    @collection = Word.page_for_administration(current_page)
  end

  # get /admin/words/:id
  def show
  end

  private

  def restrict_access
    require_privilege_group :interpreters
  end

  def set_entity
    @entity = Word.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find word #{params[:id]}")
    end
  end
end
