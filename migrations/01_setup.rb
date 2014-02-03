Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      String :username, :size=>50
      String :email, :size=>50
      String :crypted_password, :size=>70
      String :role, :size=>50
    end
    
    create_table(:tags) do
      primary_key :id
      String :name, :text=>true
    end
    
    create_table(:posts, :ignore_index_errors=>true) do
      primary_key :id
      String :title, :text=>true, :null=>false
      DateTime :written
      TrueClass :released, :default=>false
      String :markup, :default=>"markdown", :text=>true
      String :content, :text=>true
      foreign_key :account_id, :accounts, :null=>false, :key=>[:id]
      
      index [:account_id], :name=>:index_posts_account
      index [:written, :id], :name=>:posts_written_id_idx
    end
    
    create_table(:comments, :ignore_index_errors=>true) do
      primary_key :id
      String :author, :size=>50
      String :email, :size=>50
      TrueClass :acknowledged, :default=>false
      String :body, :text=>true
      foreign_key :post_id, :posts, :null=>false, :key=>[:id]
      
      index [:post_id], :name=>:index_comments_post
    end
    
    create_table(:post_tags) do
      foreign_key :post_id, :posts, :null=>false, :key=>[:id]
      foreign_key :tag_id, :tags, :null=>false, :key=>[:id]
      
      primary_key [:post_id, :tag_id]
    end
  end
end
