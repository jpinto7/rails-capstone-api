class ThingTagsController < ApplicationController
  include ActionController::Helpers
  helper ThingsHelper
  wrap_parameters :thing_tag, include: ['tag_name', 'tag_id', 'thing_id']
  before_action :get_thing, only: [:index, :update, :destroy]
  before_action :get_thing_tag, only: [:destroy]
  before_action :authenticate_user!, only: [:index, :create, :destroy]
  after_action :verify_authorized
  #after_action :verify_policy_scoped, only: [:linkable_things]

  def index
    authorize @thing, :get_tags?
    @thing_tags = @thing.tags
  end

  def update
    thing = Thing.find(thing_tag_params[:thing_id])
    if !thing
      full_message_error "cannot find thing[#{thing_tag_params[:thing_id]}]", :bad_request
      skip_authorization
    else
      authorize thing, :add_tag?
      
      tag = Tag.find_by(name: thing_tag_params[:tag_name].parameterize('_'))
      if tag
        thing_tag = ThingTag.find_by(thing_id: thing.id, tag_id: tag.id)
        thing.tags << tag unless thing_tag
      else
        thing.tags.build(name: thing_tag_params[:tag_name])
      end
      if thing.save
        head :no_content
      else
        render json: { errors: thing.errors.messages }, status: :unprocessable_entity
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

    def thing_tag_params
      params.require(:thing_tag).tap {|p|
          #_ids only required in payload when not part of URI
          p.require(:tag_name)    if !params[:tag_name]
          p.require(:thing_id)    if !params[:thing_id]
        }.permit(:tag_id, :tag_name, :thing_id)
    end
end
