# frozen_string_literal: true

require "test_helper"

class LabReportsControllerTest < ActionDispatch::IntegrationTest
  def create_user
    User.create!(
      first_name: "Иван",
      last_name: "Иванов",
      email: "#{SecureRandom.hex(10)}@example.com"
    )
  end

  def create_report(user:, title: "Report", grade: "A", description: "Описание")
    LabReport.create!(user: user, title: title, grade: grade, description: description)
  end

  test "GET / shows empty state" do
    LabReport.delete_all
    get root_path

    assert_response :success
    assert_includes response.body, "Пока нет отчётов."
  end

  test "GET /posts list shows existing reports" do
    user1 = create_user
    user2 = create_user
    report1 = create_report(user: user1, title: "Report 1", grade: "A")
    report2 = create_report(user: user2, title: "Report 2", grade: "B")

    get root_path

    assert_response :success
    assert_includes response.body, report1.title
    assert_includes response.body, report2.title
  end

  test "GET show renders report" do
    user = create_user
    report = create_report(user: user, title: "Report 1", grade: "A")

    get lab_report_path(report)

    assert_response :success
    assert_includes response.body, report.title
    assert_includes response.body, user.full_name
  end

  test "GET new renders form" do
    user = create_user
    create_report(user: user, title: "Existing", grade: "A")

    get new_lab_report_path

    assert_response :success
    assert_includes response.body, "Новый лабораторный отчёт"
  end

  test "POST create creates report with valid params" do
    user = create_user

    assert_difference "LabReport.count", 1 do
      post lab_reports_path,
           params: {
             lab_report: {
               user_id: user.id,
               title: "New report",
               description: "Описание",
               grade: "C"
             }
           }
    end

    created = LabReport.order(created_at: :desc).first
    assert_redirected_to lab_report_path(created)
    follow_redirect!
    assert_includes response.body, "New report"
  end

  test "POST create does not create report with invalid params" do
    user = create_user

    assert_no_difference "LabReport.count" do
      post lab_reports_path,
           params: {
             lab_report: {
               user_id: user.id,
               title: "",
               description: "Описание",
               grade: "A"
             }
           }
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "Ошибки"
  end

  test "GET edit renders form" do
    user = create_user
    report = create_report(user: user, title: "Report 1", grade: "A")

    get edit_lab_report_path(report)

    assert_response :success
    assert_includes response.body, "Редактировать отчёт"
  end

  test "PATCH update updates report with valid params" do
    user = create_user
    report = create_report(user: user, title: "Report 1", grade: "A")

    patch lab_report_path(report),
          params: {
            lab_report: {
              user_id: user.id,
              title: "Updated title",
              description: "Updated description",
              grade: "D"
            }
          }

    assert_redirected_to lab_report_path(report.reload)
    follow_redirect!
    assert_includes response.body, "Updated title"
  end

  test "PATCH update does not update report with invalid params" do
    user = create_user
    report = create_report(user: user, title: "Report 1", grade: "A")

    patch lab_report_path(report),
          params: {
            lab_report: {
              user_id: user.id,
              title: "",
              description: "Updated description",
              grade: "D"
            }
          }

    assert_response :unprocessable_entity
    assert_includes response.body, "Ошибки"
    assert_equal "Report 1", report.reload.title
  end

  test "DELETE destroy deletes report" do
    user = create_user
    report = create_report(user: user, title: "Report 1", grade: "A")

    assert_difference "LabReport.count", -1 do
      delete lab_report_path(report)
    end

    assert_redirected_to lab_reports_path
  end
end
