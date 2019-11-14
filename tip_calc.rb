# Displays a menu and prompt user for input
module Menu
  def prompt
      puts "
      1) Change tip percentage
      2) Re-calculate with new total
      3) Reset
      q) Quit"

      user_input = gets.chomp

      unless user_input == "q"

        case user_input
        when "1"
          puts "####################################"
          puts ""
          change_tip
          prompt
        when "2"
          puts "####################################"
          puts ""
          recalc
          prompt
        when "3"
          start
        else
          puts ''
          puts "Error:: Not a valid input."
          prompt
        end

      end

  end

  def change_tip
    tip_options # displays options to cli

    case gets.to_i
    when 1
      percent_10
    when 2
      percent_15
    when 3
      percent_20
    when 4
      user_percent
    else
      puts "Error:: Invalid input. Please enter a digit."
    end
  end

#re-calculates same tip percent with new totals
  def recalc
    # Removes previous total and tax, then promts user to enter new info
    $user_totals.pop
    $user_totals = [get_total, get_tax]

    # Gets previous selected tip from cache and calculates correct percentage
    case $cached_tip
    when "10"
      percent_10
    when "15"
      percent_15
    when "20"
      percent_20
    else
      user_percent
    end

  end

  def start
    questions #reccomends user a tip percent based on questions and gives total
    prompt
  end

end

module Questionare

  def rate
    "Enter: 1-Poor 2-Fair 3-Good 4-Excellent"
  end

  def tip_options
    puts "how much would you like to tip?"
    puts "
      1) 10%
      2) 15%
      3) 20%
      4) Enter your own amount"
  end

  def service
    puts "How was the service?"
    puts rate
  end

  def enjoyment
    puts "How well did you enjojy your experience?"
    puts rate
  end

  def total
    puts "Without counting the tax, how much was your total?"
  end

  def tax
    puts "How much is the tax?"
    puts "(include any other fee, like delivery fee or gratuity)"
  end

  def recommend_10
    puts "Based on your answers, we recommend you to tip 10%"
  end

  def recommend_15
    puts "Based on your answers, we recommend you to tip 15%"
  end

  def recommend_20
    puts "Based on your answers, we recommend you to tip 20%"
  end

  def questions
    service    
    service_rating   = get_input

    enjoyment
    enjoyment_rating = get_input

    overall_rating   = service_rating + enjoyment_rating
 
    total
    user_total = get_input

    tax
    user_tax = get_input

    $user_totals = [user_total, user_tax]

    case overall_rating
    when 2..3
      recommend_10
      percent_10
    when 4..6
      recommend_15
      percent_15
    when 7..8
      recommend_20
      percent_20
    end
  end

end

module Inputs
  # gets user input, then checks for digits and converts string to an integer
  def get_input
    input = gets

    if input_check(input) == true
      input.to_i
    end
  end
end

module Calculations
  def percent_10
    user = TipCalc.new($user_totals[0], $user_totals[1])
    user.calc_10_percent
  end

  def percent_15
    user = TipCalc.new($user_totals[0], $user_totals[1])
    user.calc_15_percent
  end

  def percent_20
    user = TipCalc.new($user_totals[0], $user_totals[1])
    user.calc_20_percent
  end

  def user_percent
    user = TipCalc.new($user_totals[0], $user_totals[1])
    user.calc_custom_percent
  end
end

module Error
  def input_check(str) # checks is string only includes digits
    unless str.scan(/^\d+$/)
      INPUT_ERROR
    else 
      true
    end
  end

  def INPUT_ERROR
    puts "::ERROR:: Not a valid input! Must be an integer."
  end
end

# Keeps track of last used percentage
class TipCache
  attr_accessor :tip_cache, :last_used_percentage, :percentage
  def initialize(percentage= 15)
    @percentage           = percentage
    @last_used_percentage = last_used_percentage
    @tip_cache            = {"10" => 10, "15" => 15, "20" => 20}
  end

  def set_last_used(data)
    last_used_percentage = data.to_s
  end

# If the percentage in the cache, set to last use. Or else store in the cache
  def cached?(percentage)
    if @tip_cache.has_key?(percentage)
    else
      @tip_cache.store("percentage", percentage)
    end
    set_last_used(percentage)
  end

  def get_last_used_percentage
    @last_used_percentage
  end

end

# Home of the tip calculations
class TipCalc
  attr_reader :total, :tax
  attr_accessor :tip

  def initialize(total, tax, tip=0)
    @total = total
    @tax   = tax
    @tip   = tip
  end

  def display_totals
    grand_total = total + tax + tip
    puts "You'll tip $#{tip.ceil(2)}"
    puts "Here's your grand total."
    puts "$#{grand_total.ceil(2)}"
  end

  def send_tip_to_cache(data)
    cache = TipCache.new(data)
    $cached_tip = cache.cached?(data)
  end

  def calc_15_percent
    @tip = 0.15 * total
    display_totals

    send_tip_to_cache(15)
  end

  def calc_10_percent
    @tip = 0.10 * total
    display_totals

    send_tip_to_cache(10)
  end

  def calc_20_percent
    @tip = 0.20 * total
    display_totals

    send_tip_to_cache(20)
  end

  def calc_custom_percent
    puts "Enter your desired percent amount:"
    percentage = gets.to_i
    TipCache.new(percentage)

    @tip = ( percentage.to_f / 100) * total
    display_totals

    send_tip_to_cache(percentage)
  end

end
include Inputs, Questionare, Menu, Error, Calculations


start
