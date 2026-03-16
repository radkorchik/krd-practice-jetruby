# students_spec.rb
require 'rspec'
require_relative 'students'

RSpec.describe 'Программа фильтрации студентов' do
  before(:each) do
    stub_const("STUDENTS_FILE", 'test_students.txt')
    stub_const("RESULTS_FILE", 'test_results.txt')
    
    sample_data = "Иван Иванов 20\nПетр Петров 21\nАнна Смирнова 20\n"
    File.write(STUDENTS_FILE, sample_data)
  end

  after(:each) do
    File.delete(STUDENTS_FILE) if File.exist?(STUDENTS_FILE)
    File.delete(RESULTS_FILE) if File.exist?(RESULTS_FILE)
  end

  describe '#filter_students' do
    it 'находит студентов по возрасту, записывает в файл и завершается при вводе -1' do
      # Имитируем ввод: сначала "20", потом "-1" (выход)
      allow_any_instance_of(Kernel).to receive(:gets).and_return("20\n", "-1\n")

      # Запускаем метод, подавляя вывод в консоль для чистоты теста
      expect { filter_students }.to output(/Найдены и перенесены студенты/).to_stdout
      
      # Проверяем, что в файл результатов записались нужные студенты
      content = File.read(RESULTS_FILE)
      expect(content).to include("Иван Иванов 20")
      expect(content).to include("Анна Смирнова 20")
      expect(content).not_to include("Петр Петров 21")
    end

    it 'завершается автоматически, когда все студенты перенесены' do
      # Имитируем ввод возрастов всех студентов по очереди
      allow_any_instance_of(Kernel).to receive(:gets).and_return("20\n", "21\n")
      
      expect { filter_students }.to output(/Все студенты из исходного файла были перенесены!/).to_stdout
      
      content = File.read(RESULTS_FILE)
      expect(content.lines.count).to eq(3) # Все три студента перенесены
    end
  end
end