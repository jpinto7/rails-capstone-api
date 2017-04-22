class Tag < ActiveRecord::Base
  has_many :thing_tags, inverse_of: :tag, dependent: :destroy
  has_many :things, through: :thing_tags
  validates :name, presence: true, uniqueness: true

  def name
    self[:name].split('_').join(' ')
  end

  def name=(val)
    self[:name] = val.parameterize('_')
  end  
end
