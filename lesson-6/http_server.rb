require 'socket'
require 'rack'
require 'rack/utils'
require 'stringio'
require_relative '../lesson-4/cash_machine'

class CashMachine
  def deposit_amount(amount)
    if amount > 0
      @balance += amount
      File.write(BALANCE_FILE, @balance.to_s)
      "Депозит успешен. Текущий баланс: #{@balance}"
    else
      "Ошибка ввода: сумма депозита должна быть положительным числом больше нуля. Повторите попытку."
    end
  end

  def withdraw_amount(amount)
    if amount <= 0
      "Ошибка ввода: сумма снятия должна быть больше нуля. Повторите попытку."
    elsif amount > @balance
      "Ошибка операции: недостаточно средств. Ваш баланс (#{@balance}) меньше запрашиваемой суммы."
    else
      @balance -= amount
      File.write(BALANCE_FILE, @balance.to_s)
      "Снятие успешно. Текущий баланс: #{@balance}"
    end
  end

  def balance_info
    "Ваш баланс составляет: #{@balance}"
  end
end

class App
  def initialize
    @cash_machine = CashMachine.new
  end

  def call(env)
    req = Rack::Request.new(env)

    case req.path
    when '/deposit'
      value = req.params['value']&.to_f

      message =
        if value.nil? || value.zero?
          "Ошибка: параметр value должен быть положительным числом."
        else
          @cash_machine.deposit_amount(value)
        end

      [200, { 'Content-Type' => 'text/plain; charset=utf-8' }, [message]]
    when '/withdraw'
      value = req.params['value']&.to_f

      message =
        if value.nil? || value.zero?
          "Ошибка: параметр value должен быть положительным числом."
        else
          @cash_machine.withdraw_amount(value)
        end

      [200, { 'Content-Type' => 'text/plain; charset=utf-8' }, [message]]
    when '/balance'
      message = @cash_machine.balance_info
      [200, { 'Content-Type' => 'text/plain; charset=utf-8' }, [message]]
    else
      [404, { 'Content-Type' => 'text/plain; charset=utf-8' }, ['Not found']]
    end
  end
end

server = TCPServer.new('0.0.0.0', 3000)
app = App.new

loop do
  connection = server.accept

  request_line = connection.gets
  next unless request_line

  method, full_path = request_line.split(' ')
  path, query = full_path.split('?', 2)

  env = {
    'REQUEST_METHOD' => method,
    'PATH_INFO' => path,
    'QUERY_STRING' => query.to_s,
    'rack.input' => StringIO.new
  }

  status, headers, body = app.call(env)

  connection.print("HTTP/1.1 #{status}\r\n")
  headers.each { |key, value| connection.print("#{key}: #{value}\r\n") }
  connection.print "\r\n"
  body.each { |part| connection.print(part) }
  connection.close
end

