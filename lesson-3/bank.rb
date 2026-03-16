BALANCE_FILE = 'balance.txt'

def bank_program
  # Читаем баланс, если файл есть, иначе берем константу
  balance = 100.0
  if File.exist?(BALANCE_FILE)
    file_content = File.read(BALANCE_FILE).chomp
    balance = file_content.to_f unless file_content.empty?
  end

  puts "Добро пожаловать в систему банка!"

  loop do
    print "\nВыберите действие: D (deposit), W (withdraw), B (balance) или Q (quit): "
    action = gets.chomp.upcase

    case action
    when 'D'
      print "Введите сумму депозита: "
      amount = gets.to_f
      
      if amount > 0
        balance += amount
        puts "Депозит успешен. Текущий баланс: #{balance}"
      else
        puts "Ошибка ввода: сумма депозита должна быть положительным числом больше нуля. Пожалуйста, попробуйте еще раз."
      end

    when 'W'
      print "Введите сумму для снятия: "
      amount = gets.to_f
      
      if amount <= 0
        puts "Ошибка ввода: сумма снятия должна быть больше нуля. Попробуйте еще раз."
      elsif amount > balance
        puts "Ошибка операции: недостаточно средств. Ваш текущий баланс (#{balance}) меньше запрашиваемой суммы."
      else
        balance -= amount
        puts "Снятие успешно. Текущий баланс: #{balance}"
      end

    when 'B'
      puts "Ваш баланс составляет: #{balance}"

    when 'Q'
      File.write(BALANCE_FILE, balance.to_s)
      puts "Баланс сохранен. Работа завершена."
      break

    else
      puts "Ошибка: Неизвестная команда '#{action}'. Пожалуйста, используйте только буквы D, W, B или Q."
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  bank_program
end