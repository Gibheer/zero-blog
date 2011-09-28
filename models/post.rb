class Post
  include DataMapper::Resource
  include DataMapper::Validate

  property :id,       Serial
  property :title,    Text,    :required => true
  property :written,  Time,    :default => lambda {|r, p| Time.now }
  property :released, Boolean, :default => false
  property :markup,   Text,    :default => 'textile'
  property :content,  Text

  belongs_to :account
  has n, :comments
  has n, :tags, :through => Resource

  def self.get_released id
    get_all_released.get(id)
  end

  def self.get_all_released
    all(:released => true)
  end

  def self.get_page page=0
    get_all_released.all(:limit => 10, :offset => (page * 10),
        :order => [:written.desc])
  end

  def self.page_count
    (get_all_released.count / 10).ceil
  end

  def self.find_of_day time
    get_all_released.all_written(time..(time+86400))
  end

  def acknowledged_comments
    comments(:acknowledged => true)
  end

  # checks if a post has this tag
  def has_tag tag
    tag_id = tag.id
    tags.any? { |t| t.id == tag_id }
  end

  # sets all tags for this post
  def set_tags new_tags
    self.tags = Tag.all(:id => new_tags)
  end
end
