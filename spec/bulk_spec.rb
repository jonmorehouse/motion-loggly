describe "Bulk" do
  extend WebStub::SpecHelpers
  
  before do
    @bulk = LogglyAPI::Bulk.new TOKEN, :tags => "default"
    @stub = stub_request(:post, "http://logs-01.loggly.com/bulk/TOKEN/tag/default")
    @response = {"response" => "ok"}
    @stub.to_return(json: @response)
    @msgs = [
      {
        :msg => "msg",
        :timestamp => "timestamp"
      },
      {
        :msg => "msg",
        :timestamp => "timestamp"
      }
    ]
    @runner = Proc.new do
      @bulk.send(@msgs) do |result|
        @result = result
        resume
      end
    end
  end

  it "should request the loggly api with an array of hashes" do
    @runner.call()
    wait_max 1.0 do
      BW::JSON.parse(@result.body).should == @response
      @result.ok?.should == true
    end
  end

  it "should request the loggly api with the correct parameters" do

    @stub.with_callback do |headers, body|
      body.kind_of?(Array).should.be.true
      body.should == stringify_array(body)
    end
    @runner.call()
    wait_max 1.0 do end
  end

end

