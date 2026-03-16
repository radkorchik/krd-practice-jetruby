# bank_spec.rb
require 'rspec'
require_relative 'bank'

RSpec.describe 'Банковская программа' do
  before(:each) do
    stub_const("BALANCE_FILE", 'test_balance.txt')
    # Устанавливаем начальный баланс 100.0
    File.write(BALANCE_FILE, "100.0")
  end

  after(:each) do
    File.delete(BALANCE_FILE) if File.exist?(BALANCE_FILE)
  end

  describe '#bank_program' do
    it 'выводит текущий баланс' do
      # Имитируем ввод: 'B' (баланс), затем 'Q' (выход)
      allow_any_instance_of(Kernel).to receive(:gets).and_return("B\n", "Q\n")
      
      expect { bank_program }.to output(/Ваш баланс составляет: 100.0/).to_stdout
    end

    it 'пополняет баланс' do
      # Ввод: 'D' (депозит), '50' (сумма), 'Q' (выход)
      allow_any_instance_of(Kernel).to receive(:gets).and_return("D\n", "50\n", "Q\n")
      
      expect { bank_program }.to output(/Депозит успешен. Текущий баланс: 150.0/).to_stdout
      
      # Проверяем, что баланс сохранился в файл после выхода
      expect(File.read(BALANCE_FILE)).to eq("150.0")
    end

    it 'успешно снимает средства, если их достаточно' do
      # Ввод: 'W' (снятие), '30' (сумма), 'Q' (выход)
      allow_any_instance_of(Kernel).to receive(:gets).and_return("W\n", "30\n", "Q\n")
      
      expect { bank_program }.to output(/Снятие успешно. Текущий баланс: 70.0/).to_stdout
    end

    it 'отказывает в снятии, если средств недостаточно' do
      # Ввод: 'W' (снятие), '150' (сумма больше баланса), 'Q' (выход)
      allow_any_instance_of(Kernel).to receive(:gets).and_return("W\n", "150\n", "Q\n")
      
      expect { bank_program }.to output(/Ошибка операции: недостаточно средств/).to_stdout
    end
  end
end