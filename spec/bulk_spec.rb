describe "Bulk" do
  extend WebStub::SpecHelpers
  before do
    @msgs = [
      {
        :url => "http://logs-01.loggly.com/bulk/#{TOKEN}/tag/tag1",
        :msg => "msg1",
        :timestamp => "timestamp1",
        :tags => ["tag1"]
      },
      #{
        #:url => "http://logs-01.loggly.com/bulk/#{TOKEN}/tag",
        #:msg => "msg1",
        #:timestamp => "timestamp2",
      #},
      {
        :url => "http://logs-01.loggly.com/bulk/#{TOKEN}/tag/tag2",
        :msg => "msg1",
        :tag => :tag2
      }
    ]
  end
  
  describe "Api call with normalized tag structure" do
    before do
      @bulk = Loggly::Bulk.new TOKEN, :tags => "default"
      @response = {"response" => "ok"}
      @stubs = []
      @msgs.each do |msg|
        stub = stub_request(:post, msg[:url])
        stub.to_return(json: @response)
        @stubs.push(stub)
      end

      # submit messages using bulk object
      @runner = Proc.new do
        @bulk.send(@msgs) do |results|
          @results = results
          resume
        end
      end
    end

    describe "Bulk message requests" do

      before do
        @requests = []
        @called = 0
        @stubs.each do |stub|
          stub.with_callback do |headers, body|
            puts "ASDF"
            @called += 1
            @requests.push({:headers => headers, :body => body})
          end
        end
        @runner.call()
        wait_max 3.0 do
        end
      end

      it "should post the messages to unique urls" do 

        @stubs.each do |stub|
          stub.should.be.requested
        end
        #@stubs.should.equal 1

      end
    end

    #it "should successfully post the messages to the correct urls" do
      #@runner.call()
      #wait_max 3.0 do
        #@results[0].success?.should.be.true
        #BW::JSON.parse(@results[0].object).should == @response
        #1.should == 1
      #end
    #end

  end

end

