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
    puts "How much is the tax? (include any other fee, like delivery fee or gratuity)"
    gets.to_f
  end

  def recommend_10
    puts "Based on your answers, we reccomend you to tip 10%"
    user_total = get_total
    user_tax   = get_tax
    user = TipCalc.new(user_total, user_tax)
    user.calc_10_percent
  end

  def recommend_15
    puts "Based on your answers, we reccomend you to tip 15%"
    user_total = get_total
    user_tax   = get_tax
    user = TipCalc.new(user_total, user_tax)
    user.calc_15_percent
  end

  def recommend_20
    puts "Based on your answers, we reccomend you to tip 20%"
    user_total = get_total
    user_tax   = get_tax
    user = TipCalc.new(user_total, user_tax)
    user.calc_20_percent
  end

  def questions
    service_rating   = get_service
    enjoyment_rating = get_enjoyment
    overall_rating   = service_rating + enjoyment_rating

    case overall_rating
    when 2..3
      recommend_10
    when 4..6
      recommend_15
    when 7..8
      recommend_20
    end
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
    puts "Here's your Grand total."
    puts "$#{grand_total.ceil(2)}"
  end

  def calc_15_percent
    @tip = 0.15 * total
    total_promt
  end

  def calc_10_percent
    @tip = 0.10 * total
    total_promt
  end

  def calc_20_percent
    @tip = 0.20 * total
    total_promt
  end

  def calc_custom_percent
    puts "Enter your desired percent amount:"

    @tip = (gets.to_f / 100) * total
    total_promt
  end

end

include Questionare

questions
