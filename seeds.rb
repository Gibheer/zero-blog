gib = Account.new(
  :username => 'Gibheer',
  :password => 'food',
  :password_confirmation => 'food',
  :email => 'foo@bar.com',
  :role => 'admin'
)
gib.save
storm = Account.new(
  :username => 'Stormwind',
  :password => 'bard',
  :password_confirmation => 'bard',
  :email => 'bar@foo.com',
  :role => 'admin'
)
storm.save

(1..50).each do |i|
  gib.posts.new(:title => "post #{i}", :content => "content of post #{i}",
                :released => true).save
end
(1..50).each do |i|
  storm.posts.new(:title => "post #{i}", :content => "content of post #{i}",
                :released => true).save
end
storm.posts.new(:title => 'bar', :content => 'this is my post!').save
gib.posts.new(:title => 'foo', :content => 'this is mine!', :released => true).save
gib.posts.new(:title => 'lala', :content => 'lorem ipsum in the round about').save
storm.posts.new(:title => 'first!', :content => 'i\'m at the top!',
                :released => true).save
Post.last.comments.new(:author => 'Gibheer', :email => 'foo@bar.com',
                       :acknowledged => true, :body => 'ipsum ipsum ipsum').save
gib.posts.new(:title => 'with markdown', :content => 'this is some `code`',
              :markup => 'markdown', :released => true).save
Post.last.comments.new(:author => 'Gibheer', :email => 'foo@bar.com',
                       :acknowledged => false, :body => 'lorem lorem ipsum').save
Post.last.comments.new(:author => 'Stormwind', :email => 'bar@foo.com',
                       :acknowledged => true, :body => 'lorem ipsum').save
