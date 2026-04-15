# frozen_string_literal: true

class AddUidToDivers < ActiveRecord::Migration[8.1]
  def change
    add_column :divers, :uid, :string
    add_index :divers, :uid, unique: true, where: "uid IS NOT NULL"
  end
end
