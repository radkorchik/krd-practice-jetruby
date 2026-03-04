def collect_pokemons
  puts 'Сколько покемонов добавить?'
  count = gets.to_i

  pokemons = []

  count.times do |index|
    puts "Введите имя покемона ##{index + 1}:"
    name = gets.chomp

    puts "Введите цвет покемона ##{index + 1}:"
    color = gets.chomp

    pokemons << { name: name, color: color }
  end

  puts pokemons.inspect
  pokemons
end

if __FILE__ == $0
  collect_pokemons
end

