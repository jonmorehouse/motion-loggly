describe "Bulk" do
  extend WebStub::SpecHelpers
  before do
    @msgs = [
      {
        :msg => "msg1",
        :timestamp => "timestamp1",
        :tags => ["tag1"]
      },
      {
        :msg => "msg1",
        :timestamp => "timestamp2",
      },
      {
        :msg => "msg1",
        :tag => :tag2
      }
    ]
  end
  
  describe "Api call with normalized tag structure" do
    before do
      @bulk = Loggly::Bulk.new TOKEN, :tags => "default"
      @stub = stub_request(:post, "http://logs-01.loggly.com/bulk/TOKEN/tag/default")
      @response = {"response" => "ok"}
      @stub.to_return(json: @response)
      @runner = Proc.new do
        @bulk.send(@msgs) do |results|
          @results = results
          resume
        end
      end
    end

    it "successfully post the callbacks to the correct urls" do
      @runner.call()
      wait_max 3.0 do
        @results[0].success?.should.be.true
        BW::JSON.parse(@results[0].object).should == @response
        1.should == 1
      end
    end

    it "should request the loggly api with the correct parameters" do

      @called = 0
      @stub.with_callback do |headers, body|
        puts "ASDF"
        @called += 1
      end
      @runner.call()
      wait_max 1.0 do end
      @called.should.equal 3
    end
  end

  describe "Multiple tags for different messages" do

    before do
      @bulk = Loggly::Bulk.new TOKEN, :tags => ["object"]
    end
    
    it "should parse the message list and pass different tags for different messages, grouping the bulk requests together" do
      1.should == 1
      @bulk.parse_tags(@msgs)

    end

  end
end

