class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.string :address
      t.string :ip_address
      t.string :nickname
      t.decimal :latitude
      t.decimal :longitude
      t.string :timezone
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
