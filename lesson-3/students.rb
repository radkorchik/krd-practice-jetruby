STUDENTS_FILE = 'students.txt'
RESULTS_FILE = 'results.txt'

# Создадим файл для примера, если его нет
unless File.exist?(STUDENTS_FILE)
  sample_data = "Иван Иванов 20\nПетр Петров 21\nАнна Смирнова 20\nСергей Сергеев 22\nОльга Попова 21\n" +
                "Алексей Ильин 23\nМария Кузнецова 20\nДмитрий Соколов 24\nЕлена Васильева 21\nМаксим Волков 22\n"
  File.write(STUDENTS_FILE, sample_data)
end

def filter_students
  all_students = File.readlines(STUDENTS_FILE).map(&:chomp)
  saved_students = []
  
  # Очищаем или создаем файл результатов перед началом
  File.write(RESULTS_FILE, "")
  
  loop do
    print "Введите возраст студента (или -1 для выхода): "
    input = gets.chomp
    
    break if input == "-1"
    
    found_any = false
    
    all_students.each do |student|
      # Разбиваем строку по пробелам и берем последний элемент (возраст)
      age = student.split.last 
      
      # Если возраст совпал и мы еще не добавляли этого студента
      if age == input && !saved_students.include?(student)
        File.write(RESULTS_FILE, "#{student}\n", mode: "a")
        saved_students << student
        found_any = true
      end
    end
    
    if found_any
      puts "=> Найдены и перенесены студенты с возрастом #{input}."
    else
      puts "=> Студентов такого возраста не найдено (или они уже перенесены)."
    end
    
    # Завершаем, если все студенты перенесены
    if saved_students.size == all_students.size
      puts "\nВсе студенты из исходного файла были перенесены!"
      break
    end
  end
  
  puts "\n--- Содержимое файла #{RESULTS_FILE} ---"
  File.foreach(RESULTS_FILE) { |line| puts line } if File.exist?(RESULTS_FILE)
end

if __FILE__ == $PROGRAM_NAME
  filter_students
end