# frozen_string_literal: true

class ShortLinksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :fetch_short_link, only: %i[index show]
  before_action :fetch_private_short_link, only: %i[edit update]

  def new
    @short_link = ShortLink.new
  end

  def create
    @short_link = ShortLink.new(new_short_link_params)
    if @short_link.save
      redirect_to short_link_admin_path(@short_link.admin_secret)
    else
      render 'new'
    end
  end

  def show
    if @short_link
      @short_link.increment!(:view_count)
      redirect_to @short_link.original_url, status: 301
    end
  end

  def edit; end

  def update
    if @short_link.update(short_link_params)
      redirect_to short_link_admin_path(@short_link.admin_secret)
    else
      render 'edit'
    end
  end

  private

  def record_not_found
    render file: "#{Rails.root}/public/404.html", status: 404
  end

  def new_short_link_params
    params.require(:short_link).permit(%i[admin_secret original_url active])
  end

  def short_link_params
    params.permit(%i[admin_secret original_url active])
  end

  def fetch_private_short_link
    @short_link = ShortLink.find_by!(admin_secret: short_link_params[:admin_secret])
  end

  def fetch_short_link
    @short_link = ShortLink.find_by_short_code(params[:short_code])
  end
end
