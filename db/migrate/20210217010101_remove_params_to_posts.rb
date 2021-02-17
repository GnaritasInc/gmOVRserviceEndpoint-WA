class RemoveParamsToPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :query_string 
    remove_column :posts, :headers 
  end
end