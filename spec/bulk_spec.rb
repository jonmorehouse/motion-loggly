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
    
    #@runner.call()

    wait_max 1.0 do
      puts "finished"
      1.should == 1
    end

  end

  #it "should raise an error when not passed an array" do

  #end


end

