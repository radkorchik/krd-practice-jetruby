# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user is valid" do
    user = User.new(
      first_name: "Иван",
      last_name: "Иванов",
      email: "ivanov@example.com",
      password: "secret123",
      password_confirmation: "secret123"
    )
    assert user.valid?
  end

  test "first_name is required and limited" do
    user = User.new(last_name: "Иванов", email: "ivanov@example.com")
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :first_name

    user = User.new(first_name: "a" * 101, last_name: "Иванов", email: "ivanov2@example.com")
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :first_name
  end

  test "last_name is required and limited" do
    user = User.new(first_name: "Иван", email: "ivanov@example.com")
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :last_name

    user = User.new(first_name: "Иван", last_name: "a" * 101, email: "ivanov2@example.com")
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :last_name
  end

  test "email is required, validated for format and length" do
    user = User.new(first_name: "Иван", last_name: "Иванов")
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :email

    user = User.new(first_name: "Иван", last_name: "Иванов", email: "not-an-email")
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :email

    long_email = "a" * 145 + "@example.com"
    user = User.new(first_name: "Иван", last_name: "Иванов", email: long_email)
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :email
  end

  test "full_name returns last name and first name" do
    user = User.create!(
      first_name: "Иван",
      last_name: "Иванов",
      email: "full-name@example.com",
      password: "secret123",
      password_confirmation: "secret123"
    )
    assert_equal "Иванов Иван", user.full_name
  end
end
