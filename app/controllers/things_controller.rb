class ThingsController < ApplicationController
  include ActionController::Helpers
  helper ThingsHelper
  before_action :set_thing, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  wrap_parameters :thing, include: ["name", "description", "notes", "tags"]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  def index
    authorize Thing
    thing_query = params[:tag].blank? ? Thing.all : Thing.with_tag(params[:tag])
    things = policy_scope(thing_query)
    @things = ThingPolicy.merge(things)
  end

  def show
    authorize @thing
    things = ThingPolicy::Scope.new(current_user,
                                    Thing.where(:id=>@thing.id))
                                    .user_roles(false)
    @thing = ThingPolicy.merge(things).first
  end

  def create
    authorize Thing
    @thing = Thing.new(thing_params)

    User.transaction do
      if @thing.save
        role=current_user.add_role(Role::ORGANIZER,@thing)
        @thing.user_roles << role.role_name
        role.save!
        render :show, status: :created, location: @thing
      else
        render json: {errors:@thing.errors.messages}, status: :unprocessable_entity
      end
    end
  end

  def update
    @thing.tags.map { |tag| @thing.tags.delete(tag) unless (tags_params.any? { |tag_param| tag_param[:id] == tag.id }) }
    tags_params.map do |tag_param|
      tag = Tag.find_by(name: tag_param[:name].parameterize('_'))
      if tag
        thing_tag = ThingTag.find_by(thing_id: @thing.id, tag_id: tag.id)
        @thing.tags << tag unless thing_tag
      else
        @thing.tags.build(name: tag_param[:name])
      end
    end
    authorize @thing
    if @thing.update(thing_params)
      head :no_content
    else
      render json: {errors:@thing.errors.messages}, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @thing
    @thing.destroy

    head :no_content
  end

  private

    def set_thing
      @thing = Thing.find(params[:id])
    end

    def thing_params
      params.require(:thing).tap {|p|
          p.require(:name) #throws ActionController::ParameterMissing
        }.permit(:name, :description, :notes)
    end

    def tags_params
      params.require(:thing).permit({ tags: [:id, :name] })[:tags] || []
    end
end
