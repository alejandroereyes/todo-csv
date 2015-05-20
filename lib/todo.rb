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
      puts "       4) Edit Todo 5) Delete Todo"
      print " > "
      action = gets.chomp.to_i
      case action
      when 1 then exit
      when 2 then add_todo
      when 3 then mark_todo
      when 4 then edit_todo
      when 5 then delete_todo
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

  def edit_todo
    puts ""
    print "Which to adjust?  1) Unfinished or 2) Completed item : "
    user_choice = get_input.to_i
    puts ""
    print "Select which item to edit: "
    element_num = get_input.to_i - 1
    puts ""
    puts "Enter your update to this item :"
    update_from_user = get_input
    # from unfinished list
    if user_choice == 1
      # look at every unfinished item
      no_group = @todos.select { |row| row['completed'] == "no" }
      # get item name value from no-list
      no_item_to_update = no_group[element_num]['name']
      # look for a match in DB and update
      @todos.each do |row|
        if row['name'] == no_item_to_update
          row['name'] = update_from_user
        end # cond
      end # each loop
    # from completed list
    elsif user_choice == 2
       # look at every completed item that is completed
      yes_group = @todos.select { |row| row['completed'] == "yes" }
      # get item name value from yes-list
      yes_item_to_update = yes_group[element_num]['name']
      # look for a match in DB and delete
      @todos.each do |row|
        if row['name'] == yes_item_to_update
          row['name'] = update_from_user
        end # cond
      end # each loop
    else # invalid entry
      puts "!!  Invalid Entry !!"
      edit_todo
    end # user_choice cond
    save!
  end # edit_todo method

  def delete_todo
    puts ""
    print "From which to list?  1) Unfinished or 2) Completed item : "
    list_choice = get_input.to_i
    puts ""
    print "Select which item to delete: "
    element_num = get_input.to_i - 1
    # from unfinished list
    if list_choice == 1
      # look at every unfinished item
      no_group = @todos.select { |row| row['completed'] == "no" }
      # get item name value from no-list
      no_item_to_delete = no_group[element_num]['name']
      # look for a match in DB and update
      @todos.delete_if { |row| row['name'] == no_item_to_delete}
    # from completed list
    elsif list_choice == 2
       # look at every completed item
      yes_group = @todos.select { |row| row['completed'] == "yes" }
      # get item name value from yes-list
      yes_item_to_delete = yes_group[element_num]['name']
      # look for a match in DB and update
      @todos.delete_if { |row| row['name'] == yes_item_to_delete}
    else # invalid entry
      puts "!!  Invalid Entry !!"
      delete_todo
    end # user_choice cond
    save!


  end # delete_todo method

  private
  def get_input
    gets.chomp
  end

  def save!
    File.write(@file_name, @todos.to_csv)
  end
end
