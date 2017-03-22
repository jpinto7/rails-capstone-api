class ThingTagsController < ApplicationController
  include ActionController::Helpers
  helper ThingsHelper
  wrap_parameters :thing_tags, include: ['tags', 'thing_id']
  before_action :get_thing, only: [:index, :create]
  before_action :check_empty_tags, only: [:create]
  before_action :authenticate_user!, only: [:index, :create]
  after_action :verify_authorized

  def index
    authorize @thing, :get_tags?
    @thing_tags = @thing.tags
  end

  def create
    if !@thing
      full_message_error "cannot find thing[#{params[:thing_id]}]", :bad_request
      skip_authorization
    else
      authorize @thing, :assign_tags?
      delete_tags @thing
      assign_tags @thing
      if @thing.save
        head :no_content
      else
        render json: { errors: thing.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  private
    def get_thing
      @thing ||= Thing.find(params[:thing_id])
    end

    def check_empty_tags
      params[:tags] ||= []
    end

    def delete_tags(thing)
      thing.tags.map do |thing_tag|
        thing.tags.delete(thing_tag) unless params[:tags].any? { |tag| tag[:id] == thing_tag.id }
      end
    end

    def assign_tags(thing)
      params[:tags].each do |tag|
        found_tag = Tag.find_by(name: tag[:name].parameterize('_'))
        if found_tag
          thing_tag = ThingTag.find_by(thing_id: thing.id, tag_id: found_tag.id)
          thing.tags << found_tag unless thing_tag
        else
          thing.tags.build(name: tag[:name])
        end
      end
    end
end
