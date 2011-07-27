class Tag
  include DataMapper::Resource
  include DataMapper::Validate

  property :id, Serial
  property :name, Text

  has n, :posts, :through => Resource
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of   :name
end
