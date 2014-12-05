require "spec_helper"

describe BusinessHours do
  describe "#calculate_deadline" do
    before do
      @bh = BusinessHours.new("8:00 AM", "5:00 PM")
    end

    it "when start time is within business hours" do
      deadline = Time.parse("Dec 23, 2009 3:05 PM")
      expect(@bh.calculate_deadline(5*60, "Dec 23, 2009 3:00 PM")).to \
        eq(deadline)
    end

    it "when start time is before business hours" do
      deadline = Time.parse("Dec 23, 2009 8:05 AM")
      expect(@bh.calculate_deadline(5*60, "Dec 23, 2009 7:55 AM")).to \
        eq(deadline)
    end

    it "when start time is after business hours" do
      deadline = Time.parse("Dec 23, 2009 8:05 AM")
      expect(@bh.calculate_deadline(5*60, "Dec 22, 2009 6:37 PM")).to \
        eq(deadline)
    end

    it "when there is carry over to next day" do
      deadline = Time.parse("Dec 23, 2009 8:02 AM")
      expect(@bh.calculate_deadline(5*60, "Dec 22, 2009 4:57 PM")).to \
        eq(deadline)
    end

    it "when the next day is skipped" do
      deadline = Time.parse("Dec 23, 2009 8:57 AM")
      expect(@bh.calculate_deadline(10*60*60, "Dec 21, 2009 4:57 PM")).to \
        eq(deadline)
    end

    it "when start time is before business hours & the next day is skipped" do
      deadline = Time.parse("Dec 23, 2009 9:00 AM")
      expect(@bh.calculate_deadline(10*60*60, "Dec 22, 2009 7:55 AM")).to \
         eq(deadline)
    end

    it "update hours of day" do
      @bh.update :mon, "8:00 AM", "3:00 PM"
      @bh.update :tue, "9:00 AM", "5:00 PM"
      deadline = Time.parse("Dec 22, 2009 9:02 AM")
      expect(@bh.calculate_deadline(5*60, "Dec 21, 2009 2:57 PM")).to \
        eq(deadline)
    end

    it "skips closed days" do
      @bh.closed :sat, :sun
      deadline = Time.parse("Dec 21, 2009 8:02 AM")
      expect(@bh.calculate_deadline(5*60, "Dec 18, 2009 4:57 PM")).to \
        eq(deadline)
    end

    it "changes hours on specific dates" do
      @bh.update "Dec 24, 2009", "8:00 AM", "3:00 PM"
      @bh.closed :sat, :sun, "Dec 25, 2009"
      deadline1 = Time.parse("Dec 28, 2009 8:02 AM")
      expect(@bh.calculate_deadline(5*60, "Dec 24, 2009 2:57 PM")).to \
        eq(deadline1)
      deadline2 = Time.parse("Dec 17, 2009 3:02 PM")
      expect(@bh.calculate_deadline(5*60, "Dec 17, 2009 2:57 PM")).to \
        eq(deadline2)
    end

    it "when starts on a closed day" do
      @bh.closed :tue, "Dec 25, 2009"
      deadline1 = Time.parse("Dec 23, 2009 8:05 AM")
      expect(@bh.calculate_deadline(5*60, "Dec 22, 2009 4:57 PM")).to \
        eq(deadline1)
      deadline2 = Time.parse("Dec 26, 2009 8:05 AM")
      expect(@bh.calculate_deadline(5*60, "Dec 25, 2009 4:57 PM")).to \
        eq(deadline2)
    end

  end
end

