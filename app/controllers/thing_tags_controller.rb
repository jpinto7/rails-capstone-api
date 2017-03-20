class ThingTagsController < ApplicationController
  include ActionController::Helpers
  helper ThingsHelper
  wrap_parameters :thing_tag, include: ['tag_id', 'thing_id']
  before_action :get_thing, only: [:index, :update, :destroy]
  before_action :get_thing_tag, only: [:destroy]
  before_action :authenticate_user!, only: [:index, :create, :destroy]
  after_action :verify_authorized
  #after_action :verify_policy_scoped, only: [:linkable_things]

  def index
    authorize @thing, :get_tags?
    @thing_tags = @thing.tags
  end

  def create
    tag = Tag.find_or_create_by_(name: thing_tag_create_params[:name])
    thing_tag = ThingTag.find_by(thing_id: thing_tag_create_params[:thing_id], tag_id: tag.id)


    thing_tag = ThingTag.new(thing_tag_create_params.merge({
                                  tag_id: params[:tag_id],
                                  thing_id: params[:thing_id],
                                  }))
    thing = Thing.where(id: thing_tag.thing_id).first
    if !thing
      full_message_error "cannot find thing[#{params[:thing_id]}]", :bad_request
      skip_authorization
    elsif !Thing.where(id: thing_tag.tag_id).exists?
      full_message_error "cannot find tag[#{params[:tag_id]}]", :bad_request
      skip_authorization
    else
      authorize thing, :add_tag?
      if thing_tag.save
        head :no_content
      else
        render json: {errors: @thing_tag.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    authorize @thing, :remove_tag?
    @thing_tag.destroy
    head :no_content
  end

  private
    def get_thing
      @thing ||= Thing.find(params[:thing_id])
    end

    def get_tag
      @tag ||= Tag.find(params[:tag_id])
    end

    def get_thing_tag
      @thing_tag ||= ThingTag.find(params[:id])
    end

    def thing_tag_create_params
      params.require(:thing_tag).tap {|p|
          #_ids only required in payload when not part of URI
          p.require(:name)    if !params[:name]
          p.require(:thing_id)    if !params[:thing_id]
        }.permit(:name, :thing_id)
    end
end
