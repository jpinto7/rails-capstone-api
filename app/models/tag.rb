class Tag < ActiveRecord::Base
  has_many :thing_tags, inverse_of: :tag, dependent: :destroy  
end
