module Routes
  class Post < Controller
    PREV_AND_NEXT_QUERY = <<SQL
      select (
        select id from posts where written < ? and released order by written desc limit 1
      ) older,
      (
        select id from posts where written > ? and released order by written limit 1
      ) younger
SQL

    def self.get(session)
      define_posts(session)
      session.options[:render] = 'posts/index'
    end

    def self.define_posts(session)
      posts = DB[:posts].
        filter(:released => true).
        select(:posts__id___post_id, :written, :title, :content, :username).
        join(:accounts, :id___account_id => :account_id).
        reverse_order(:written, :posts__id)

      if session.options[:id]
        posts = posts.filter(:posts__id => session.options[:id].to_i)
        load_previous_and_next_post(session, posts) unless posts.empty?
      else
        if session.request.params['search']
          posts = load_fulltextsearch(session, posts)
        end
        load_page_information(session, posts)
        # return no_results if posts.empty?
      end

      session.options[:posts] = posts
    end

    # load posts depending on the pagination
    def self.load_page_information(session, posts)
      # compute pages
      page = session.request.params['page'].to_i
      session.options[:page] = page if page
      per_page = session.request.params['per_page'].to_i
      per_page = 10 if per_page < 1
      session.options[:query][:per_page] = per_page if per_page
      session.options[:pages] = posts.count / per_page
    end

    # load a single posts and the ids of the next and previous posts
    def self.load_previous_and_next_post(session, posts)
      written = posts.first[:written]
      session.options[:post_ids_pn] = DB[PREV_AND_NEXT_QUERY, written, written].first
    end

    # adjust query to use fulltext search
    def self.load_fulltextsearch(session, posts)
      session.options[:query][:search] = session.request.params['search']
      posts.filter(
        'posts.search_field @@ to_tsquery(\'english\', ?)',
        session.request.params['search'].tr(' ', '&')
      )
    end
  end
end
