# frozen_string_literal: true

# Managing own dreams of user
class My::DreamsController < ProfileController
  # get /my/dreams
  def index
    @collection = Dream.list_for_owner(current_user).page(current_page)
  end

  # get /my/dreams/:id
  def show
    @entity = Dream.owned_by(current_user).find(params[:id])
    handle_http_404('Cannot find dream') if @entity.nil?
  end
end
