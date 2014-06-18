describe "Event" do
  #extend WebStub::SpecHelpers
  
  before do
    @event = LogglyAPI::Event.new TOKEN, :tags => "default"
  end

  it "should build a post request and call it with the request class" do
    #stub_request(:post, "http://
    @event.send("msg") do |result|
      @result = result.success?
      resume
    end
    wait_max 1.0 do
      @result.should == true
    end
    1.should == 1
  end

end

