require_relative 'foobar'

RSpec.describe '#foobar' do
  it 'возвращает второе число, если первое равно 20' do
    expect(foobar(20, 5)).to eq(5)
  end

  it 'возвращает второе число, если второе равно 20' do
    expect(foobar(7, 20)).to eq(20)
  end

  it 'возвращает сумму, если ни одно не равно 20' do
    expect(foobar(3, 4)).to eq(7)
  end

  it 'корректно обрабатывает случай, когда оба числа равны 20' do
    expect(foobar(20, 20)).to eq(20)
  end
end


