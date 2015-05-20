require 'csv'

class Todo

  def initialize(file_name)
    @file_name = file_name
    # You will need to read from your CSV here and assign them to the @todos variable. make sure headers are set to true
    @todos = CSV.read(@file_name, headers: true)
  end

  def start
    loop do
      system('clear')

      puts "---- TODO.rb ----"

      view_todos

      puts
      puts "What would you like to do?"
      puts "1) Exit 2) Add Todo 3) Mark Todo As Complete"
      print " > "
      action = gets.chomp.to_i
      case action
      when 1 then exit
      when 2 then add_todo
      when 3 then mark_todo
      else
        puts "\a"
        puts "Not a valid choice"
      end
    end
  end

  def todos
    @todos
  end

  def view_todos
    puts "Unfinished"
    need = @todos.select { |row| row['completed'] == "no" }
    counter = 0
    need.each do |task|
      counter += 1
      puts "#{counter}) #{task['name']}"
    end

    puts "Completed"
    donzo = @todos.select { |row| row['completed'] == "yes" }
    counter = 0
    donzo.each do |task|
      counter += 1
      puts "#{counter}) #{task['name']}"
    end
  end # view_todos method

  def add_todo
    puts "Name of Todo > "
    @todos << [get_input, "no"]
    save!
  end # add_todo method

  def mark_todo
    puts "Which todo have you finished?"
    @todos[get_input.to_i - 1]['completed'] = "yes"
    save!
  end # mark_todo method

  private
  def get_input
    gets.chomp
  end

  def save!
    File.write(@file_name, @todos.to_csv)
  end
end
