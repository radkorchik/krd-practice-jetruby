# frozen_string_literal: true

class LabReport < ApplicationRecord
  belongs_to :user

  ECTS_GRADES = %w[A B C D E FX F].freeze

  validates :title, presence: true, length: { maximum: 250 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :grade, inclusion: { in: ECTS_GRADES }, allow_blank: true
end
