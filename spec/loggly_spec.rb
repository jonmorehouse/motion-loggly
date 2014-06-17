describe "Loggly" do
  
  describe "send_event", do

    before do
      @loggly = Loggly.new TOKEN, {}
      @counter = 0
      @loggly.stub :thing, return: "a thing"

    end

    after do

    end

    it "should create an Event object on the first event submission" do

      @loggly.event("msg")
      @counter.should == 0
      Loggly.any_instance.stub!(:test) do
        puts "no"
      end
      #@loggly.stub!(:test) do 
        #puts "here"
      #end
      @loggly.test


    end


  end
  
end
