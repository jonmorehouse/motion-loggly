class AppDelegate 

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    token = "a1a8d452-281f-40aa-ac4e-ff29d1e0a0e0"
    msgs = [
      {
        :msg => "some message"
      }
    ]

    bulk = Loggly::Bulk.new token, :tags => "bulk-test"
    #semaphore = Dispatch::Semaphore.new 0
    #puts "START WAITING"
    #bulk.send(msgs) do |result|
      #semaphore.signal
      #puts result.success?
    #end
    #semaphore.wait
    #puts "END"

  end

  @token = "a1a8d452-281f-40aa-ac4e-ff29d1e0a0e0"

  @apiroot = "http://logs-01.loggly.com/"
  @endpoint = "inputs/#{@token}/tag/msg,default"


  @url = "http://logs-01.loggly.com/inputs/#{@token}/tag/msg,default"
  @data = {:msg => "message"}

  def self.bubblewrap

    BW::HTTP.post("#{@url}", {payload: @data, format: :json}) do |result|
      puts "Bubblewrap: #{result.ok?}"
      puts "Bubblewrap Body: #{result.body}"
    end

  end

  def self.afmotion

    # curl --data  '{"msg":"value"}' -H 'Content-Type: application/json' http://logs-01.loggly.com/inputs/TOKEN/tag/msg,default
    AFMotion::JSON.post(@url, @data) do |result|
      puts "JSON was #{result.success?}"
      puts "Body #{result.object}"
      puts "Body #{result.error.localizedDescription}"
    end

    #AFMotion::HTTP.post(url, {:msg => "value"}) do |result|
      #puts "HTTP was #{result.success?}"
    #end
  end

  def self.localhost

    AFMotion::JSON.post("http://172.16.42.42:8080", msg: "charlotte is cute") do |result|

      puts result.success?

    end


  end
  def self.client

    client = AFMotion::Client.build(@apiroot) do

      header "Content-Type", "application/json"
      request_serializer :json
      header "Accept", "text/html"
      #response_serializer :json
      
    end

    client.post(@endpoint, @data) do |result|

      puts result.success?
      puts result.error.localizedDescription 
      @result = result

    end
  end


end
