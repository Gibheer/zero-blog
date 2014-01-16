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

      # return when a single posts has to be shown
      return load_previous_and_next_post(session, posts) if session.options[:id]
      load_page_information(session, posts)
    end

    def self.load_page_information(session, posts)
      # compute pages
      page = session.request.params['page'].to_i
      session.options[:page] = page if page
      per_page = session.request.params['per_page'].to_i
      per_page = 10 if per_page < 1
      session.options[:per_page] = per_page if per_page
      session.options[:pages] = DB[:posts].filter(:released => true).count / per_page

      # fetch the posts to show
      session.options[:posts]  = posts.limit(per_page, page * per_page)
    end

    def self.load_previous_and_next_post(session, posts)
      posts = posts.filter(:posts__id => session.options[:id].to_i)
      session.options[:posts] = posts
      written = posts.first[:written]
      session.options[:post_ids_pn] = DB[PREV_AND_NEXT_QUERY, written, written].first
    end
  end
end
