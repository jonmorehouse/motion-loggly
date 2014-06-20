describe "Loggly" do
  before do
    @loggly = Loggly.new TOKEN, {}
    @event_counter = 0
    @bulk_counter = 0

    # stub event
    @event = Loggly::Event.new TOKEN
    @event.stub! :send do |args, opts|
      @event_counter += 1
      @args = args
      @opts = opts
    end
    @loggly.stub!(:event_logger, return: @event)

    # stub bulk
    @bulk = Loggly::Bulk.new TOKEN 
    @bulk.stub! :send do |args, opts|
      @bulk_counter += 1
      @args = args
      @opts = opts
    end
    @loggly.stub!(:bulk_logger, return: @bulk)
  end
  
  describe "send_event", do

    it "should delegate the message to the correct object with the correct options" do
      msg = "msg"
      @loggly.event(msg)
      @event_counter.should == 1
      @args.should == msg
    end
  end

  describe "send_bulk", do

    it "should delegate the message to the correct object with the correct options", do
      msg = "bulk"
      @loggly.bulk(msg)
      @bulk_counter.should == 1
      @args.should == msg
    end
  end

  describe "send", do

    it "should use the bulk logger when passing an array", do
      msg = ["array", "of", "messages"]
      @loggly.send(msg)
      @bulk_counter.should == 1

    end

    it "should use the event logger a hash is passed in", do
      msg = {:key => :value}
      @loggly.send(msg)
      @event_counter.should == 1
    end

    it "should use the event logger when a string is passed in", do
      msg = "msg"
      @loggly.send(msg)
      @event_counter.should == 1
    end
  end
end
