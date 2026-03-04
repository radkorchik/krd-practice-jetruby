require 'rspec'
require_relative 'word_script'

RSpec.describe '#process_word' do
  it 'возвращает 2 в степени длины слова, если заканчивается на CS в верхнем регистре' do
    expect(process_word('ABCS')).to eq(2**4)
  end

  it 'возвращает 2 в степени длины слова, если заканчивается на CS в любом регистре' do
    expect(process_word('learnCs')).to eq(2**7)
  end

  it 'возвращает слово задом наперёд, если не заканчивается на CS' do
    expect(process_word('ruby')).to eq('ybur')
  end
end

