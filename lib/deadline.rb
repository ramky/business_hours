require 'date'
require 'time'

class Deadline
  attr_reader :schedules, :remaining, :start_time

  def initialize(schedules, remaining, start_time)
    @schedules, @remaining = schedules, remaining
    @start_time = Time.parse(start_time)
  end

  def calculate
    increment_day while after_today?
    start_or_opening_time + remaining
  end

private
  def after_today?
    start_or_opening_time + remaining > closing_time
  end

  def increment_day
    if start_time < closing_time
      @remaining -= closing_time - start_or_opening_time
    end
    @start_time = opening_time + 24*60*60
    #require 'pry'; binding.pry
  end

  def start_or_opening_time
    [start_time, opening_time].max
  end

  def opening_time
    Time.parse("#{start_time_date} #{get_opening}")
  end

  def closing_time
    Time.parse("#{start_time_date} #{get_closing}")
  end

  # 2009-12-23
  def start_time_date
    "#{start_time.year}-#{start_time.month}-#{start_time.day}"
  end

  def get_opening
    get_opening_or_closing_for_date(start_time_date,'opening') ||
      get_opening_or_closing_for_day('opening') ||
      "#{schedules[:default].opening}"
  end

  def get_closing
    get_opening_or_closing_for_date(start_time_date,'closing') ||
      get_opening_or_closing_for_day('closing') ||
      "#{schedules[:default].closing}"
  end

  def get_opening_or_closing_for_date(date, key)
    schedules.has_key?(date) ? "#{schedules[date].send(key)}" : nil
  end

  def get_opening_or_closing_for_day(key)
    symbol = get_symbol_for_abbr_day
    schedules.has_key?(symbol) ? "#{schedules[symbol].send(key)}" : nil
  end

  def get_symbol_for_abbr_day
    abbr_day = Date::ABBR_DAYNAMES[start_time.wday]
    abbr_day.downcase.to_sym
  end
end

