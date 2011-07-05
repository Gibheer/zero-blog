class Comment
  include DataMapper::Resource
  include DataMapper::Validate

  property :id, Serial
  property :author, String
  property :email, String
  property :acknowledged, Boolean, :default => false
  property :body, Text
  belongs_to :post

  validates_presence_of :author, :email, :body
  validates_length_of   :email,  :min => 3, :max => 100
  validates_format_of   :email,  :with => :email_address

  # overwrite the default to_json, because we don't need all fields
  def to_json ressource_options
    {
      :id => id,
      :post_id => post.id,
      :author => author,
      :body => body
    }
  end
end
