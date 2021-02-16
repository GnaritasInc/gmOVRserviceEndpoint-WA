class AddParamsToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :query_string, :text
    add_column :posts, :headers, :text
  end
end
