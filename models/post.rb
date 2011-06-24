class Post
  include DataMapper::Resource
  include DataMapper::Validate

  property :id,       Serial
  property :title,    Text,    :required => true
  property :written,  Time,    :default => lambda { Time.now }
  property :released, Boolean, :default => false
  property :markup,   Text,    :default => 'textile'
  property :content,  Text

  belongs_to :account
end
