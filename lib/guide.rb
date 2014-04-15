require 'restaurant'
require 'support/string_extend'

class Guide
  class Config 
    @@actions = ['list', 'find', 'add', 'quit']
    def self.actions
      @@actions
    end
  end
  
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
      action, args = get_action
      # Do that action
      result = do_action(action, args)
    end
    conclusion
  end
  
  def get_action
    action = nil
    # Keep asking for input until we get a valid action
    until Guide::Config.actions.include?(action)
      # What do you want to do? (list, find, add, quit)
      puts "Action: " + Guide::Config.actions.join(", ") if action
      print "> "
      user_response = gets.chomp
      args = user_response.downcase.strip.split(' ')
      action = args.shift
    end
    return action, args
  end
  
  def do_action(action, args=[])
    case action
    when 'list'
      list
    when 'find'
      keyword = args.shift
      find(keyword)
    when 'add'
      add
    when 'quit'
      return :quit
    else
      puts "\nI don't understand that command.\n"
    end
  end
  
  def add
    output_action_header("Add restaurants")
    restaurant = Restaurant.build_using_questions
    
    if restaurant.save
      puts "\nRestaurant added\n\n"
    else
      puts "\nError: Restaurant not added\n\n"
    end
  end
  
  def find(keyword="")
    output_action_header("Find restaurants")
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |rest|
        rest.name.downcase.include?(keyword.downcase) ||
        rest.cuisine.downcase.include?(keyword.downcase) ||
        rest.price.to_i <= keyword.to_i
      end
      output_restaurant_table(found)
    else
      puts "Find using a key phrase to search the restaurant list."
    end
  end
  
  def list
    output_action_header("Listing restaurants")
    restaurants = Restaurant.saved_restaurants
    output_restaurant_table(restaurants)
  end
  
  def introduction
    puts "\n\n<<< Welcome to the Food Finder >>>\n\n"
    puts "This is an interactive guide to help you find the food you crave.\n\n"
  end
  
  def conclusion
    puts "\n<<< Goodbye and Bon Appetit! >>>\n\n\n"
  end
  
  private
  def output_action_header(text)
    puts "\n#{text.center(60)}\n\n"
  end
  
  def output_restaurant_table(restaurants=[])
    print " " + "Name".titleize.ljust(30)
    print " " + "Name".titleize.ljust(20)
    print " " + "Name".rjust(6) + "\n"
    puts "-" * 60
    restaurants.each do |rest|
      line = " " << rest.name.titleize.ljust(30)
      line << " " + rest.cuisine.titleize.ljust(20)
      line << " " + rest.formatted_price.rjust(6)
      puts line
    end
    puts "No listing found" if restaurants.empty?
    puts "-" * 60
  end
end
