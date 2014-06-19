module LogglyAPI 

  class Bulk < Base

    @endpoint = "bulk"
    class << self 
      attr_accessor :endpoint
    end

    # expects an array of objects
    # assumes that you are running a bit more sophisticated. eg: doesn't include timestamps automatically
    # expects data to be an array of hashes
    def send(msgs, opts = {}, &cb)
      raise ArgumentError, "invalid method name" unless msgs.kind_of?(Array)
      @cb = cb
      tags = normalize_tags opts
      url = build_url(tags)
      @cb.call("asdfasdf")
    end

  end

end
