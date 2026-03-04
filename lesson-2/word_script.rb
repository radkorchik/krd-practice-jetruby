def process_word(word)
  if word.downcase.end_with?('cs')
    2**word.length
  else
    word.reverse
  end
end

if __FILE__ == $0
  puts 'Введите слово:'
  input = gets.chomp
  puts process_word(input)
end

