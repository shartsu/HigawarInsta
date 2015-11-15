class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.string :url
      t.string :caption
      t.timestamps null: false
    end
  end
end
