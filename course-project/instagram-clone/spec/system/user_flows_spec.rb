require "rails_helper"

RSpec.describe "User flows", type: :system do
  it "allows sign up and log in" do
    visit new_user_registration_path
    fill_in "Имя пользователя", with: "alice"
    fill_in "Email", with: "alice@example.com"
    fill_in "Пароль", with: "password123"
    fill_in "Подтверждение пароля", with: "password123"
    click_button "Создать аккаунт"

    expect(page).to have_content("Добро пожаловать! Регистрация выполнена успешно.")

    click_button "Выйти"
    visit new_user_session_path
    fill_in "Email", with: "alice@example.com"
    fill_in "Пароль", with: "password123"
    click_button "Войти"
    expect(page).to have_content("Лента")
  end

  it "creates and edits own post with image" do
    user = build_user(username: "owner", email: "owner@example.com")
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Пароль", with: "password123"
    click_button "Войти"

    click_link "Новый пост"
    fill_in "Подпись", with: "my first image"
    attach_file "Изображение", Rails.root.join("spec/fixtures/files/test-image.svg")
    click_button "Опубликовать пост"

    expect(page).to have_content("my first image")

    click_link "Редактировать"
    fill_in "Подпись", with: "updated caption"
    click_button "Сохранить изменения"
    expect(page).to have_content("updated caption")
  end

  it "supports follow/unfollow, comments and likes" do
    owner = build_user(username: "bob", email: "bob@example.com")
    follower = build_user(username: "mike", email: "mike@example.com")
    post = owner.posts.new(caption: "bob post")
    post.image.attach(Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test-image.svg"), "image/svg+xml"))
    post.save!

    visit new_user_session_path
    fill_in "Email", with: follower.email
    fill_in "Пароль", with: "password123"
    click_button "Войти"

    click_link "Пользователи"
    click_button "Подписаться"
    expect(page).to have_button("Отписаться")

    click_link "Лента"
    expect(page).to have_content("bob post")

    click_link "Открыть пост"
    fill_in "Текст комментария", with: "nice"
    click_button "Добавить комментарий"
    expect(page).to have_content("nice")
    click_button "Лайк"
    expect(page).to have_content("Лайки: 1")
    click_button "Дизлайк"
    expect(page).to have_content("Лайки: 0")
    expect(page).to have_content("Дизлайки: 1")
  end
end
