FILE_PATH = 'data.txt'
BUFFER_PATH = 'buffer.txt'

# Убедимся, что файл существует, создав пустой, если его нет
File.write(FILE_PATH, "") unless File.exist?(FILE_PATH)

# Read: выводит все строки
def index
  File.foreach(FILE_PATH) { |line| puts line }
end

# Read: находит конкретную строку по id (номеру строки)
def find(id)
  File.foreach(FILE_PATH).with_index do |line, index|
    puts line if index == id
  end
end

# Read: находит все строки, где есть указанный паттерн
def where(pattern)
  File.foreach(FILE_PATH) do |line|
    puts line if line.include?(pattern)
  end
end

# Update: обновляет конкретную строку файла
def update(id, text)
  file = File.open(BUFFER_PATH, 'w')
  File.foreach(FILE_PATH).with_index do |line, index|
    # Если номер строки совпадает, пишем новый текст, иначе оставляем старый
    file.puts(id == index ? text : line.chomp)
  end
  file.close
  
  # Перезаписываем основной файл и удаляем буфер
  File.write(FILE_PATH, File.read(BUFFER_PATH))
  File.delete(BUFFER_PATH) if File.exist?(BUFFER_PATH)
end

# Delete: удаляет строку
def delete(id)
  file = File.open(BUFFER_PATH, 'w')
  File.foreach(FILE_PATH).with_index do |line, index|
    # Записываем все строки, кроме той, чей id совпал
    file.puts(line) unless id == index
  end
  file.close
  
  File.write(FILE_PATH, File.read(BUFFER_PATH))
  File.delete(BUFFER_PATH) if File.exist?(BUFFER_PATH)
end

# Create: добавляет строку в конец файла
def create(name)
  File.write(FILE_PATH, "#{name}\n", mode: "a")
end

if __FILE__ == $PROGRAM_NAME
  create("Тестовая строка")
  index
end