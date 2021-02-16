class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :request
      t.string :endpoint
      t.text :response
      t.timestamps
    end
  end
end
