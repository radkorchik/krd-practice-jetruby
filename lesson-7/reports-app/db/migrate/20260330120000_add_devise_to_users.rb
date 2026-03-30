# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.1]
  def change
    # Needed by Devise's :database_authenticatable module.
    change_table :users do |t|
      t.string :encrypted_password, null: false, default: ""
    end
  end
end

