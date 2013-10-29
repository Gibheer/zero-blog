module Routes
  class Post < Controller
    def self.get(session)
      define_posts(session)
      session.options[:render] = 'posts/index'
    end

    def self.define_posts(session)
      # compute pages
      page = session.request.params['page'].to_i
      session.options[:page] = page if page
      per_page = session.request.params['per_page'].to_i
      per_page = 10 if per_page == 0
      session.options[:per_page] = per_page if per_page
      session.options[:pages] = DB[:posts].filter(:released => true).count / per_page

      # fetch the posts to show
      posts = DB[:posts].
        filter(:released => true).
        select(:posts__id___post_id, :written, :title, :content, :username).
        join(:accounts, :id___account_id => :account_id).
        reverse_order(:written)
      if session.options[:id]
        posts = posts.where(:posts__id => session.options[:id]) 
      end
      session.options[:posts]  = posts.limit(per_page, page * per_page)
    end
  end
end
