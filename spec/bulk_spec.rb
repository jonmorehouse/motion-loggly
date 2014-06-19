describe "Event" do
  extend WebStub::SpecHelpers
  
  before do
    @bulk = LogglyAPI::Bulk.new TOKEN, :tags => "default"
    @stub = stub_request(:post, "http://logs-01.loggly.com/bulk/TOKEN/tag/default")
    @stub.to_return(json: {:response => "ok"})
    @msgs = []
      #{
        #:msg => "msg",
        #:timestamp => "timestamp"
      #},
      #{
        #:msg => "msg",
        #:timestamp => "timestamp"
      #}
    #]

  end

  it "should request the loggly api with an array of hashes" do

    Dispatch::Queue.main.async do
      sleep 1
      resume
    end

    s = Dispatch::Semaphore.new 0
    q = Dispatch::Queue.new("test")
    q.async do 
      s.signal
      Dispatch::Queue.main.sync do
        #puts "do something on the main thread, from the background thread"
      end
    end

    s.wait
    wait_max 5 do
      1.should == 1
      puts "HERE"

    end
    

  end

  #it "should raise an error when not passed an array" do

  #end


end

