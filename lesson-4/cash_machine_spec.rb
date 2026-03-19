require 'rspec'
require_relative 'cash_machine'

RSpec.describe CashMachine do
  # Создаем изолированный файл баланса для тестов
  let(:test_balance_file) { 'test_balance.txt' }

  before(:each) do
    stub_const("CashMachine::BALANCE_FILE", test_balance_file)
    File.write(test_balance_file, "100.0") # Стартовый баланс
  end

  after(:each) do
    File.delete(test_balance_file) if File.exist?(test_balance_file)
  end

  describe '.init (запуск программы)' do
    it 'выводит текущий баланс' do
      # Имитируем ввод: 'B' (баланс), 'Q' (выход)
      allow_any_instance_of(Kernel).to receive(:gets).and_return("B\n", "Q\n")
      expect { CashMachine.init }.to output(/Ваш баланс составляет: 100.0/).to_stdout
    end

    it 'успешно пополняет баланс' do
      # Имитируем ввод: 'D' (депозит), '50', 'Q' (выход)
      allow_any_instance_of(Kernel).to receive(:gets).and_return("D\n", "50\n", "Q\n")
      expect { CashMachine.init }.to output(/Текущий баланс: 150.0/).to_stdout
      
      # Проверяем, что в файл записалась правильная сумма
      expect(File.read(test_balance_file)).to eq("150.0")
    end

    it 'успешно снимает деньги' do
      # Имитируем ввод: 'W' (снятие), '30', 'Q' (выход)
      allow_any_instance_of(Kernel).to receive(:gets).and_return("W\n", "30\n", "Q\n")
      expect { CashMachine.init }.to output(/Текущий баланс: 70.0/).to_stdout
    end
  end
end