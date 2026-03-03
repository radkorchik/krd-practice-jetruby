def greeting
  puts 'Введите имя:'
  first_name = gets.chomp

  puts 'Введите фамилию:'
  last_name = gets.chomp

  puts 'Введите возраст:'
  age = gets.to_i

  if age < 18
    puts "Привет, #{first_name} #{last_name}. Тебе меньше 18 лет, но начать учиться программировать никогда не рано"
  else
    puts "Привет, #{first_name} #{last_name}. Самое время заняться делом!"
  end
end

if __FILE__ == $0
    greeting
  end