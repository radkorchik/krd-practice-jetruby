# frozen_string_literal: true

require "test_helper"

class LabReportTest < ActiveSupport::TestCase
  def build_user
    User.create!(first_name: "Иван", last_name: "Иванов", email: "lab-#{SecureRandom.hex(6)}@example.com")
  end

  test "valid report is valid" do
    user = build_user
    report = LabReport.new(user: user, title: "Отчёт 1", description: "Описание", grade: "A")
    assert report.valid?
  end

  test "title is required and limited" do
    user = build_user
    report = LabReport.new(user: user, title: nil, description: "Описание", grade: "A")
    assert_not report.valid?
    assert_includes report.errors.attribute_names, "title"

    report = LabReport.new(user: user, title: "a" * 251, description: "Описание", grade: "A")
    assert_not report.valid?
    assert_includes report.errors.attribute_names, "title"
  end

  test "description length is limited and optional" do
    user = build_user

    report = LabReport.new(user: user, title: "Отчёт 1", description: nil, grade: "A")
    assert report.valid?

    report = LabReport.new(user: user, title: "Отчёт 1", description: "a" * 501, grade: "A")
    assert_not report.valid?
    assert_includes report.errors.attribute_names, "description"
  end

  test "grade must be an ECTS grade when present" do
    user = build_user

    report = LabReport.new(user: user, title: "Отчёт 1", description: nil, grade: nil)
    assert report.valid?

    report = LabReport.new(user: user, title: "Отчёт 1", description: nil, grade: "")
    assert report.valid?

    report = LabReport.new(user: user, title: "Отчёт 1", description: nil, grade: "Z")
    assert_not report.valid?
    assert_includes report.errors.attribute_names, "grade"
  end

  test "belongs_to user is required" do
    report = LabReport.new(title: "Отчёт 1", description: "Описание", grade: "A")
    assert_not report.valid?
    assert_includes report.errors.attribute_names, "user"
  end
end
