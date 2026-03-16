# crud_spec.rb
require 'rspec'
require_relative 'crud' # Подключаем ваш файл с методами

RSpec.describe 'Методы CRUD для работы с файлами' do
  # Создаем временный файл перед каждым тестом
  before(:each) do
    # Для тестов переопределяем константы внутри методов
    # В реальном приложении лучше передавать путь к файлу как аргумент
    stub_const("FILE_PATH", 'test_data.txt')
    stub_const("BUFFER_PATH", 'test_buffer.txt')
    
    File.write(FILE_PATH, "Строка 1\nСтрока 2\nСтрока 3\n")
  end

  # Удаляем временные файлы после каждого теста
  after(:each) do
    File.delete(FILE_PATH) if File.exist?(FILE_PATH)
    File.delete(BUFFER_PATH) if File.exist?(BUFFER_PATH)
  end

  describe '#index' do
    it 'выводит все строки из файла' do
      expected_output = "Строка 1\nСтрока 2\nСтрока 3\n"
      expect { index }.to output(expected_output).to_stdout
    end
  end

  describe '#find' do
    it 'выводит конкретную строку по id (индексу)' do
      expected_output = "Строка 2\n"
      expect { find(1) }.to output(expected_output).to_stdout
    end
  end

  describe '#where' do
    it 'находит и выводит строки по паттерну' do
      File.write(FILE_PATH, "Яблоко\nБанан\nЯблочный сок\n", mode: "a")
      expected_output = "Яблоко\nЯблочный сок\n"
      expect { where('Ябло') }.to output(expected_output).to_stdout
    end
  end

  describe '#update' do
    it 'обновляет строку по указанному id' do
      update(1, "Обновленная строка 2")
      content = File.read(FILE_PATH)
      expect(content).to include("Обновленная строка 2\n")
      expect(content).not_to include("Строка 2\n")
    end
  end

  describe '#delete' do
    it 'удаляет строку по указанному id' do
      delete(0)
      content = File.read(FILE_PATH)
      expect(content).to eq("Строка 2\nСтрока 3\n")
    end
  end

  describe '#create' do
    it 'добавляет новую строку в конец файла' do
      create("Новая строка 4")
      content = File.read(FILE_PATH)
      expect(content).to end_with("Новая строка 4\n")
    end
  end
end