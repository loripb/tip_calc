module Questionare
  def rate
    puts "Enter: 1-Poor 2-Fair 3-Good 4-Excellent"
  end

  def get_service
    puts "How was the service?"
    rate
    service_rating = gets.to_i
  end

  def get_enjoyment
    puts "How well did you enjojy your experience?"
    rate
    enjoyment_rating = gets.to_i
  end

  def questionare
    get_service
    get_enjoyment
    overall_rating = service_rating + enjoyment_rating

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
  include Questionare
  
  attr_reader :total, :tax
  attr_accessor :tip

  def initialize(total, tax, tip=0)
    @total = total
    @tax   = tax
    @tip   = tip
  end

  def total_promt
    grand_total = total + tax + tip
    puts "Your tip is #{tip}"
    puts "Here's your Grand total."
    puts "$#{grand_total}"
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
