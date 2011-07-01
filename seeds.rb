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

storm.posts.new(:title => 'bar', :content => 'das ist mein post!').save
gib.posts.new(:title => 'foo', :content => 'das ist meiner',
              :released => true).save
gib.posts.new(:title => 'lala', :content => 'lorem ipsum und so rum').save
storm.posts.new(:title => 'erster!', :content => 'ich bin *ganz* oben!',
                :released => true).save
gib.posts.new(:title => 'mit markdown', :content => 'das ist `code` und so',
              :markup => 'markdown', :released => true).save
