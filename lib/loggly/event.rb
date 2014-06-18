module LogglyAPI
  class Event < Base
    @@endpoint = "inputs"

    def send(msg, opts = {}, &cb)
      # generate url with tags
      @cb = cb
      tags = normalize_tags opts
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
