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

  def send(msg, opts = {})
    if msg.kind_of?(Array)
      logger = bulk_logger
    else
      logger = event_logger
    end
    logger.send(msg,opts)
  end

  def send_event(msg, opts = {})
    event_logger.send(msg, opts)
  end

  def send_bulk(messages, opts = {})
    bulk_logger.send(messages, opts)
  end

  private
  def event_logger
    if not @event_logger
      @event_logger = Loggly::Event.new @token, @opts
    end
    return @event_logger
  end

  def bulk_logger
    if not @bulk_logger
      @bulk_logger = Loggly::Bulk.new @token, @opts
    end
    return @bulk_logger

  end

  # method aliases
  alias :event :send_event
  alias :bulk :send_bulk

end
