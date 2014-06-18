describe "Event" do
  extend WebStub::SpecHelpers
  
  before do
    @event = LogglyAPI::Event.new TOKEN, :tags => "default"
  end

  it "should build a post request and call it with the request class" do
    stub = stub_request(:post, "http://logs-01.loggly.com/inputs/TOKEN/tag/default")
    stub.to_return(json: {:response => "ok"})

    @event.send("msg") do |result|
      @result = result
      resume
    end
    wait_max 1.0 do
      @result.success?.should == true
      #@result.body.should == {:response => "ok"}
    end
  end

end

