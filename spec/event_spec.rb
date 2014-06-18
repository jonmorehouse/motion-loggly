describe "Event" do
  
  before do
    @event = LogglyAPI::Event.new TOKEN, :tags => "default"
  end

  it "should build a post request and call it with the request class" do
    1.should == 1
    @semaphore = Dispatch::Semaphore.new 0
    @event.send("msg", :tag => "msg") do |err|
    end
    Dispatch::Queue.concurrent("test").sync do
      wait 4
      @semaphore.signal
    end

    @semaphore.wait
    puts RUBYMOTION_ENV
  end

end

