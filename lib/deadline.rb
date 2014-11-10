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
    @remaining -= closing_time - start_or_opening_time if start_time < closing_time
    @start_time = opening_time + 24*60*60
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
    "#{schedules[:default].opening}"
  end

  def get_closing
    "#{schedules[:default].closing}"
  end

  def opening_for_day
    "#{schedules[start_time.wday].opening}"
  end

  def closing_for_day
    "#{schedules[start_time.wday].closing}"
  end

  #def work_start_time
  #  if start_time < opening_time
  #      opening_time
  #  elsif start_time > closing_time
  #     opening_time + 24*60*60
  #  else
  #    if start_time + remaining < closing_time
  #      start_time
  #    else
  #      completed = closing_time - start_time
  #      @remaining -= completed
  #      opening_time + 24*60*60
  #    end
  #  end
  #end
end
