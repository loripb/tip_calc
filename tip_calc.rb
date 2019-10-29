module Menu
  def prompt
      puts "
      1) Change tip percentage (COMING SOON)
      2) Re-calculate with new total
      3) Reset
      q) Quit"

      user_input = gets.chomp

      unless user_input == "q"

        case user_input
        when "1"
          change_tip
          prompt
        when "2"
          puts "~~~~~~~~~~~~~~~~~~~~~~~~~~"
          recalc
          prompt
        when "3"
          start
        else
          puts "Error:: Not a valid input."
        end

      end

  end

  def change_tip
  end

  def recalc
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
    questions
    prompt
  end

  def test_prompt
    prompt
  end
end

module Questionare
  def rate
    puts "Enter: 1-Poor 2-Fair 3-Good 4-Excellent"
  end

  def get_service
    puts "How was the service?"
    rate
    gets.to_i
  end

  def get_enjoyment
    puts "How well did you enjojy your experience?"
    rate
    gets.to_i
  end

  def get_total
    puts "Without counting the tax, how much was your total?"
    gets.to_f
  end

  def get_tax
    puts "How much is the tax?"
    puts "(include any other fee, like delivery fee or gratuity)"
    gets.to_f
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
    include Calculations
    service_rating   = get_service
    enjoyment_rating = get_enjoyment
    overall_rating   = service_rating + enjoyment_rating

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

module Calculations
  def percent_10
    user_total = get_total
    user_tax   = get_tax
    user = TipCalc.new(user_total, user_tax)
    user.calc_10_percent
  end

  def percent_15
    user_total = get_total
    user_tax   = get_tax
    user = TipCalc.new(user_total, user_tax)
    user.calc_15_percent
  end

  def percent_20
    user_total = get_total
    user_tax   = get_tax
    user = TipCalc.new(user_total, user_tax)
    user.calc_20_percent
  end

  def user_percent
    user_total = get_total
    user_tax   = get_tax
    user = TipCalc.new(user_total, user_tax)
    user.calc_custom_percent
  end
end

class Memory
  attr_accessor :tip_cache, :last_used_percentage, :percentage
  def initialize(percentage= 15)
    @percentage           = percentage
    @last_used_percentage = last_used_percentage
    @tip_cache            = {"10" => 10, "15" => 15, "20" => 20}
  end

  def set_last_used(data)
    last_used_percentage = data.to_s
  end

  def cached?(percentage)
    if tip_cache.has_key?(percentage)
      set_last_used(percentage)
    else
      @tip_cache.store("percentage", percentage)
      set_last_used(percentage)
    end
  end

  def get_last_used_percentage
    @last_used_percentage
  end

end

class TipCalc
  attr_reader :total, :tax
  attr_accessor :tip

  def initialize(total, tax, tip=0)
    @total = total
    @tax   = tax
    @tip   = tip
  end

  def total_promt
    grand_total = total + tax + tip
    puts "Your tip is $#{tip.ceil(2)}"
    puts "Here's your grand total."
    puts "$#{grand_total.ceil(2)}"
  end

  def send_to_cache(data)
    cache = Memory.new(data)
    $cached_tip = cache.cached?(data)
  end

  def calc_15_percent
    @tip = 0.15 * total
    total_promt

    send_to_cache(15)
  end

  def calc_10_percent
    @tip = 0.10 * total
    total_promt

    send_to_cache(10)
  end

  def calc_20_percent
    @tip = 0.20 * total
    total_promt

    send_to_cache(20)
  end

  def calc_custom_percent
    puts "Enter your desired percent amount:"
    percentage = gets
    Memory.new(percentage)

    @tip = ( percentage.to_f / 100) * total
    total_promt

    send_to_cache(percentage)
  end

end

include Questionare
include Menu

start
