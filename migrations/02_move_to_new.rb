# this is the schema from the old platform
Sequel.migration do
  up do
    drop_table :post_tags
    drop_table :comments
    drop_table :tags

    alter_table :posts  do
      add_column :language, String, :size => 10
    end

    from(:posts).update(:language => 'english')

    alter_table :posts do
      set_column_not_null :language
    end

    run 'create function search_field(posts) returns tsvector as $$' +
      "select to_tsvector($1.language::regconfig, $1.title || ' ' || $1.content);" +
      '$$ language sql immutable;'
  end

  down do
    alter_table :posts do
      drop_column :language
    end
    run 'drop function search_field(posts);'

    create_table(:tags) do
      primary_key :id
      String :name, :text=>true
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
