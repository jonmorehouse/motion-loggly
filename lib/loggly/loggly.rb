class Loggly
  def initialize(token, opts = {})
    @token = token
    if opts.has_key? :tags
      if opts.is_a Array
        @tags = [opts[:tags]]
      else
        @tags = [opts[:tags]]
      end
    else
      @tags = []
    end

  end

  def send_event(msg, opts = {})
    if not @event
      @event = LogglyAPI::Event.new(@token, :tags => @tags)
    end
    @event.send(msg, opts)
  end

  def send_bulk(messages, opts = {})


  end

  alias :event :send_event
  alias :bulk :send_bulk

  def test()

    puts "HERE"
  end
end
