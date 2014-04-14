require 'restaurant'

class Guide
  def initialize(path=nil)
    # Locate the restaurant text file at path
    Restaurant.filepath = path
    if Restaurant.file_usable?
      puts "Found restaurant file."
    # Or create a new file
    elsif Restaurant.create_file
      puts "Created restaurant file."
    # Exit if create fails
    else
      puts "Exiting...\n\n"
      exit!
    end
  end
  
  def launch!
    introduction
    # Action loop
    result = nil
    until result == :quit
      # What do you want to do? (list, find, add, quit)
      print "> "
      user_response = gets.chomp
      # Do that action
      result = do_action(user_response)
    end
    conclusion
  end
  
  def do_action(action)
    case action
    when 'list'
      puts 'Listing...'
    when 'find'
      puts 'Finding...'
    when 'add'
      puts 'Adding...'
    when 'quit'
      return :quit
    else
      puts "\nI don't understand that command.\n"
    end
  end
  
  def introduction
    puts "\n\n<<< Welcome to the Food Finder >>>\n\n"
    puts "This is an interactive guide to help you find the food you crave.\n\n"
  end
  
  def conclusion
    puts "\n<<< Goodbye and Bon Appetit! >>>\n\n\n"
  end
end
