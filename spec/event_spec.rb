describe "Event" do
  
  before do
    @event = LogglyAPI::Event.new "a1a8d452-281f-40aa-ac4e-ff29d1e0a0e0", :tags => "default"
  end

  it "should build a post request and call it with the request class" do

    1.should == 1
    @event.send "msg", :tag => "msg"
    wait 5 do

    end


  end


end



