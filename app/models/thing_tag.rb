class ThingTag < ActiveRecord::Base
  belongs_to :thing
  belongs_to :tag
  after_destroy :check_tags

  private
    def check_tags
      tag = Tag.find(tag_id)
      tag.destroy unless tag.things.count > 0
    end
end
