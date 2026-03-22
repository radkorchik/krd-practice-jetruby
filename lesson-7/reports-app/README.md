# Reports App

> Учёт лабораторных отчётов и оценок ECTS — учебный проект на Ruby on Rails (lesson 7).

Веб-приложение для ведения **отчётов по лабораторным работам** и выставления **оценок по шкале ECTS**: A, B, C, D, E, FX, F.

---

## Возможности

| | |
|--|--|
| CRUD | Список, просмотр, создание, редактирование и удаление отчётов |
| Студенты | Каждый отчёт привязан к пользователю (`User`) |
| Валидации | Длины полей, формат email, допустимые оценки ECTS |

---

## Стек

- **Rails** 8.x  
- **SQLite** (development)  
- **ERB**, Propshaft  

---

## Быстрый старт

```bash
cd lesson-7/reports-app
bundle install
bin/rails db:migrate db:seed
bin/rails server
```

Сайт: [http://localhost:3000](http://localhost:3000)

---

## Пользователи (студенты)

Отдельная регистрация в интерфейсе по заданию не обязательна. Данные можно завести через **сиды** или **консоль**:

```bash
bin/rails console
```

```ruby
User.create!(first_name: "Имя", last_name: "Фамилия", email: "student@example.com")
```

---

## Модель данных

- **`users`** — `first_name`, `last_name`, `email` (уникальный индекс)  
- **`lab_reports`** — `title`, `description`, `grade`, внешний ключ `user_id`  

---

## Лицензия

Учебный проект в рамках курса.
