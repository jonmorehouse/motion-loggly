# Rubymotion Loggly
> wrapper for logging to the [Loggly Api](https://www.loggly.com/docs/api-overview/) from rubymotion

## Usage

Event usage
~~~ ruby 
event = Loggly::Event.new token, {:tags => ["event", "rubymotion"]}

event.send("your message", tags: "single-event")

# sends a timestamped message to the api
# {:msg => "your message", :timestamp => "some iso8601 timestamp"}
~~~

Bulk usage
~~~ ruby 
bulk = Loggly::Bulk.new token, {:tags => ["bulk", "rubymotion"]}

# send an array of messages to the api
bulk.send([{:msg => "message 1", :timestamp => "iso8601 timestamp"}, {:msg => "message 2"}], tags: "single-event")

~~~


