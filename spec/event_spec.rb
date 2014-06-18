describe "Event" do
  
  before do
    @event = LogglyAPI::Event.new TOKEN, :tags => "default"
  end

  it "should build a post request and call it with the request class" do
    puts "\n"
    1.should == 1
    semaphore = Dispatch::Semaphore.new 0
    @event.send("msg") do
      puts "finished"
      puts semaphore.signal
    end
    q = Dispatch::Queue.new("test")
    q.async do
      puts "start"
      sleep 2
      puts "stop"
      semaphore.signal
    end
    semaphore.wait

  end

end

