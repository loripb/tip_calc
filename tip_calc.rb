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
    desired_tip = gets.to_f

    @tip = (desired_tip / 100) * total
    total_promt
  end

end
