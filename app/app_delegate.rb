class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions) end

  def self.test

    q = Dispatch::Queue.new("test")
    g = Dispatch::Group.new
    s = Dispatch::Semaphore.new 0
    c = AFMotion::SessionClient.build "http://www.espn.com", do |c|
      c.session_configuration :ephemeral
      c.response_serializer :http
    end

    q.async do
      c.get("nfl") do |result|
        puts "Result called"
      end
    end
    
    q.wait

    puts "DONE DONE DONE"


  end
end
