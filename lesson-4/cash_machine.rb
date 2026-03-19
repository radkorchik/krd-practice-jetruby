class CashMachine
    BALANCE_FILE = 'balance.txt'
  
    # Конструктор: вызывается при создании нового объекта CashMachine.new
    def initialize
      @balance = 100.0 # Константа по умолчанию
      
      if File.exist?(BALANCE_FILE)
        file_content = File.read(BALANCE_FILE).chomp
        @balance = file_content.to_f unless file_content.empty?
      end
    end
  
    # Метод класса для инициализации и запуска программы
    def self.init
      machine = new # Создаем экземпляр класса
      machine.start # Запускаем основной цикл
    end
  
    # Основной метод экземпляра (публичный)
    def start
      puts "Добро пожаловать в систему банка!"
      
      loop do
        print "\nВыберите действие: D (deposit), W (withdraw), B (balance) или Q (quit): "
        action = gets.chomp.upcase
  
        case action
        when 'D' then deposit
        when 'W' then withdraw
        when 'B' then balance
        when 'Q'
          quit
          break
        else
          puts "Ошибка: Неизвестная команда '#{action}'. Пожалуйста, введите одну из букв: D, W, B или Q."
        end
      end
    end
  
    private # Скрываем внутренние методы логики от вызова извне
  
    def deposit
      print "Введите сумму депозита: "
      amount = gets.to_f
      
      if amount > 0
        @balance += amount
        puts "Депозит успешен. Текущий баланс: #{@balance}"
      else
        puts "Ошибка ввода: сумма депозита должна быть положительным числом больше нуля. Повторите попытку."
      end
    end
  
    def withdraw
      print "Введите сумму для снятия: "
      amount = gets.to_f
      
      if amount <= 0
        puts "Ошибка ввода: сумма снятия должна быть больше нуля. Повторите попытку."
      elsif amount > @balance
        puts "Ошибка операции: недостаточно средств. Ваш баланс (#{@balance}) меньше запрашиваемой суммы."
      else
        @balance -= amount
        puts "Снятие успешно. Текущий баланс: #{@balance}"
      end
    end
  
    def balance
      puts "Ваш баланс составляет: #{@balance}"
    end
  
    def quit
      File.write(BALANCE_FILE, @balance.to_s)
      puts "Баланс сохранен. Работа завершена."
    end
  end
  
  # Запуск программы (только если файл запускается напрямую)
  if __FILE__ == $PROGRAM_NAME
    CashMachine.init
  end