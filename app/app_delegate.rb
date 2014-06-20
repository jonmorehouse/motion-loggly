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

  def self.test_call

    # curl --data  '{"msg":"value"}' -H 'Content-Type: application/json' http://logs-01.loggly.com/inputs/TOKEN/tag/msg,default
    url = "http://logs-01.loggly.com/inputs/TOKEN/tag/msg,default"
    AFMotion::JSON.post(url, {:msg => "value"}) do |result|
      puts "JSON was #{result.success?}"
    end

    AFMotion::HTTP.post(url, {:msg => "value"}) do |result|
      puts "HTTP was #{result.success?}"
    end


  end
end
