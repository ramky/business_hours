class BusinessHours
  attr_reader :schedules

  def initialize(opening, closing)
    @schedules = {}
    @schedules[:default] = Schedule.new(opening, closing)
  end

  def update(day, opening, closing)
    type = day.kind_of?(Symbol) ? day : Date.parse(day).to_s
    @schedules[type] = Schedule.new(opening, closing)
  end

  def closed(*days)
    days.each { |day| update(day, '0:00', '0.00') }
  end

  def calculate_deadline(interval, start_time)
    Deadline.new(@schedules, interval, start_time).calculate
  end
end

