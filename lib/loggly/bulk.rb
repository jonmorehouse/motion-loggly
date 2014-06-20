module Loggly 

  class Bulk < Base

    @endpoint = "bulk"
    class << self 
      attr_accessor :endpoint
    end

    # expects data to be an array of hashes
    def send(msgs, opts = {}, &cb)
      raise ArgumentError, "invalid method name" unless msgs.kind_of?(Array)
      @cb = cb
      tags = normalize_tags opts
      url = build_url(tags)
      post(url, msgs)
    end
  end
end
