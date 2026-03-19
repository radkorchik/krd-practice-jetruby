module Resource
  def connection(routes)
    if routes.nil?
      puts "No route matches for #{self}"
      return
    end

    loop do
      print 'Choose verb to interact with resources (GET/POST/PUT/DELETE) / q to exit: '
      verb = gets.chomp.upcase
      break if verb == 'Q' || verb == 'q'

      action = nil

      if verb == 'GET'
        print 'Choose action (index/show) / q to exit: '
        action = gets.chomp.downcase
        break if action == 'q'
      end

      # Вызов нужного метода контроллера
      action.nil? ? routes[verb].call : routes[verb][action].call
    end
  end
end

class PostsController
  extend Resource

  def initialize
    @posts = [] # Хранилище постов
  end

  def index
    if @posts.empty?
      puts "=> Список постов пуст."
    else
      puts "=> Все посты:"
      @posts.each_with_index do |post, index|
        puts "   #{index}. #{post}"
      end
    end
  end

  def show
    print "Введите ID поста: "
    id = gets.to_i
    
    if valid_id?(id)
      puts "=> Пост #{id}: #{@posts[id]}"
    else
      puts "=> Ошибка: Пост с ID #{id} не найден."
    end
  end

  def create
    print "Введите текст нового поста: "
    text = gets.chomp
    
    if text.strip.empty?
      puts "=> Ошибка: Текст поста не может быть пустым."
    else
      @posts << text
      puts "=> Пост успешно создан! ID: #{@posts.size - 1}"
    end
  end

  def update
    print "Введите ID поста для обновления: "
    id = gets.to_i
    
    if valid_id?(id)
      print "Введите новый текст: "
      new_text = gets.chomp
      
      if new_text.strip.empty?
        puts "=> Ошибка: Текст не может быть пустым."
      else
        @posts[id] = new_text
        puts "=> Пост #{id} успешно обновлен!"
      end
    else
      puts "=> Ошибка: Пост с ID #{id} не найден."
    end
  end

  def destroy
    print "Введите ID поста для удаления: "
    id = gets.to_i
    
    if valid_id?(id)
      deleted_post = @posts.delete_at(id)
      puts "=> Пост '#{deleted_post}' удален."
    else
      puts "=> Ошибка: Пост с ID #{id} не найден."
    end
  end

  private

  def valid_id?(id)
    id >= 0 && id < @posts.size
  end
end

class Router
  def initialize
    @routes = {}
  end

  def init
    resources(PostsController, 'posts')

    loop do
      print "\nChoose resource you want to interact (1 - Posts, 2 - Comments, q - Exit): "
      choice = gets.chomp

      break if choice == 'q' || choice == 'Q'
      
      if choice == '1'
        PostsController.connection(@routes['posts'])
      else
        puts "Ресурс пока не реализован."
      end
    end

    puts 'Good bye!'
  end

  def resources(klass, keyword)
    controller = klass.new
    @routes[keyword] = {
      'GET' => {
        'index' => controller.method(:index),
        'show'  => controller.method(:show)
      },
      'POST'   => controller.method(:create),
      'PUT'    => controller.method(:update),
      'DELETE' => controller.method(:destroy)
    }
  end
end

if __FILE__ == $PROGRAM_NAME
  router = Router.new
  router.init
end