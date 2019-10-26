class TipCalc
  attr_reader :total, :tax
  attr_accessor :tip

  def initialize(total, tax, tip=0)
    @total = total
    @tax   = tax
    @tip   = tip
  end

  def calc_15_percent
    tip = 0.15 * total
    grand_total = total + tax + tip

    puts "Your tip is #{tip}"
    puts "Here's your Grand total."
    puts "$#{grand_total}"
  end

end
