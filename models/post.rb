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
    first(:id => id, :released => true)
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
    all(:written => time..(time+86400), :releaed => true)
  end

  def acknowledged_comments
    comments(:acknowledged => true)
  end

  # checks if a post has this tag
  def has_tag tag
    tags.each do |t|
      if t.id == tag.id
        return true
      end
    end
    false
  end

  # sets all tags for this post
  def set_tags tags
    @post.tags = []
    tags.each do |tag_id|
      @post.tags << Tag.first(:id => tag_id)
    end
  end
end
