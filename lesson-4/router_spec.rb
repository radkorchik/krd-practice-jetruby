require 'rspec'
require_relative 'router'

RSpec.describe PostsController do
  # Создаем новый экземпляр контроллера перед каждым тестом
  let(:controller) { PostsController.new }

  describe '#index' do
    it 'выводит сообщение, если постов нет' do
      expect { controller.index }.to output(/Список постов пуст/).to_stdout
    end
  end

  describe '#create' do
    it 'создает новый пост' do
      # Имитируем ввод текста поста
      allow(controller).to receive(:gets).and_return("Мой первый пост\n")
      expect { controller.create }.to output(/Пост успешно создан! ID: 0/).to_stdout
      
      # Проверяем, что он теперь выводится в index
      expect { controller.index }.to output(/0. Мой первый пост/).to_stdout
    end

    it 'выдает ошибку при пустом вводе' do
      allow(controller).to receive(:gets).and_return("   \n")
      expect { controller.create }.to output(/Ошибка: Текст поста не может быть пустым/).to_stdout
    end
  end

  describe '#update' do
    it 'обновляет существующий пост' do
      # Сначала создаем пост напрямую в переменной экземпляра
      controller.instance_variable_set(:@posts, ["Старый текст"])
      
      # Имитируем ввод: ID = 0, Новый текст
      allow(controller).to receive(:gets).and_return("0\n", "Новый текст\n")
      expect { controller.update }.to output(/Пост 0 успешно обновлен!/).to_stdout
      
      # Проверяем изменения
      expect { controller.index }.to output(/0. Новый текст/).to_stdout
    end
  end
end