class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.references :attachable, polymorphic: true, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
