class Schedule
  attr_reader :opening, :closing
  def initialize(opening, closing)
    @opening = opening
    @closing = closing
  end

  def to_s
    "Opening: #{opening}, Closing: #{closing}"
  end
end
