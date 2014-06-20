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
      post(url, data(msg))
    end

    def data(msg)
      # add in a timestamp
      return {
        :timestamp => NSDate.new.string_with_format(:iso8601),
        :message => msg
      }
    end
  end
end
