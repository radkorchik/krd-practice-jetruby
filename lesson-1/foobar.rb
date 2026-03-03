def foobar(a, b)
  if a == 20 || b == 20
    b
  else
    a + b
  end
end

if __FILE__ == $0
  puts 'Введите первое число:'
  first = gets.to_i

  puts 'Введите второе число:'
  second = gets.to_i

  result = foobar(first, second)
  puts "Результат: #{result}"
end
