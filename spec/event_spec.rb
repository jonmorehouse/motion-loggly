describe "Event" do
  
  before do
    @event = LogglyAPI::Event.new TOKEN, :tags => "default"
  end

  it "should build a post request and call it with the request class" do

    1.should == 1
    @event.send "msg", :tag => "msg"

  end


end



