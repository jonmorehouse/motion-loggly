module Loggly
  class Event < Base

    @endpoint = "inputs"
    class << self 
      attr_accessor :endpoint
    end

    def send(msg, opts = {}, &cb)
      @cb = cb
      opts[:object] ||= true
      tags = normalize_tags opts, object: true
      url = build_url(tags)
      msg = normalize_msg(msg)
      post(url, msg)
    end

  end
end
