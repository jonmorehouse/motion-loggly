describe "Event" do
  extend WebStub::SpecHelpers
  
  before do
    @event = Loggly::Event.new TOKEN, :tags => "default"
    @stub = stub_request(:post, "http://logs-01.loggly.com/inputs/TOKEN/tag/default")
    @response = {"response" => "ok"}
    @stub.to_return(json: @response)
    @msg = {:msg => "message"}
    @runner = Proc.new do
      @event.send(@msg) do |result|
        @result = result
        resume
      end
    end
  end

  it "should build a post request and call it with the request class" do
    @stub.with_callback do |headers, body|
      body.has_key?("message").should.be.true
      body.has_key?("timestamp").should.be.true
    end
    @runner.call()

    wait_max 1.0 do
      BW::JSON.parse(@result.object).should == {"response" => "ok"}
      @result.success?.should == true
    end
  end
end

