# frozen_string_literal: true

class CreateLabReports < ActiveRecord::Migration[8.1]
  def change
    create_table :lab_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :description
      t.string :grade

      t.timestamps
    end
  end
end
