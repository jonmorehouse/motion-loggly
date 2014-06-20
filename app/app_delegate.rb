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
end
