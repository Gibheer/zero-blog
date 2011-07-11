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

  def self.get_released id
    first(:id => id, :released => true)
  end

  def self.get_page page=0
    all(:released => true, :limit => 10, :offset => (page * 10 + 1),
        :order => [:written.desc])
  end

  def self.find_of_day time
    all(:written => time..(time+86400), :releaed => true)
  end

  def acknowledged_comments
    comments(:acknowledged => true)
  end
end
