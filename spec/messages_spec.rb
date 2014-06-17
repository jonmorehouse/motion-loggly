describe "Messages Class" do
  before do 
    @app = UIApplication.sharedApplication
    @counter = 0
    @messages = Loggly::Messages.new :size => 1, do |results|
      @results = results
      @counter += 1
    end
  end

  it "should store messages" do
    @messages.add("new message")
    @counter.should == 1
  end
end
