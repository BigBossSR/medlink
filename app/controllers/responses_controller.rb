class ResponsesController < ApplicationController
  before_filter :initialize_response, only: [:new, :create]
  before_filter :find_response, only: [:show, :archive, :unarchive]

  def index
    authorize! :respond, User
    @responses = archived accessible_responses.page params[:response_page]
  end

  def new
    @orders = @user.orders.without_responses.
      includes(:request, :supply)
    @history = @user.orders.with_responses.
      includes(:supply).
      page(params[:page])
  end

  def create
    @response.update_attributes(response_params) || raise("Failed to update response")
    orders = params[:orders].select { |_,data| data.include? "delivery_method" }
    Order.where(id: orders.keys).includes(:request, :user, :country, :supply).each do |o|
      data = orders[o.id.to_s].merge response_id: @response.id
      o.update_attributes data.permit :delivery_method, :response_id
    end
    @response.include_updated_orders!
    @response.send!
    redirect_to manage_orders_path, flash:
      { success: I18n.t!("flash.response_sent", user: @user.name) }
  end

  def show
  end

  def archive
    @response.archive!
    redirect_to responses_path(page: params[:page]), flash:
      { success: I18n.t!("flash.response_archived") }
  end
  def unarchive
    @response.unarchive!
    redirect_to responses_path(page: params[:page]), flash:
      { success: I18n.t!("flash.response_unarchived") }
  end

  private # -----

  def initialize_response
    @user = User.find params[:user_id]
    authorize! :respond, @user
    @response = Response.new user: @user
  end

  def find_response
    id = params[:response_id] || params[:id]
    @response = Response.find id
    @user     = @response.user
    authorize! :respond, @user
  end

  def response_params
    params.require(:response).permit :extra_text
  end

  def accessible_responses
    current_user.
      accessible(Response).
      where(country_id: active_country_id).
      includes :user, :orders => :supply
  end

  def archived responses
    if params[:responses] == "archived"
      responses.where "archived_at IS NOT NULL"
    elsif params[:responses] == "all"
      responses
    else
      responses.where archived_at: nil
    end
  end
end
