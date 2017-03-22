class Thing < ActiveRecord::Base
  include Protectable
  validates :name, presence: true
  after_destroy :check_tags

  has_many :thing_images, inverse_of: :thing, dependent: :destroy
  has_many :thing_tags, inverse_of: :thing, dependent: :destroy
  has_many :tags, -> { order(:name) }, through: :thing_tags, after_remove: :check_tag_associated_things

  scope :not_linked, ->(image) { where.not(id: ThingImage.select(:thing_id).where(image: image)) }
  scope :with_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name.parameterize('_') }) }


  private
    def check_tags
      tags.destroy_all
    end

    def check_tag_associated_things(tag)
      tag.destroy unless tag.things.count > 0
    end
end
