# frozen_string_literal: true

class AddOmniauthToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :integer, null: false, default: 1

    add_index :users, :uid, unique: true, where: "(uid IS NOT NULL)"
  end
end
