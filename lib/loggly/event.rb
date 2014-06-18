module LogglyAPI
  class Event < Base
    @@endpoint = "inputs"

    def send(msg, opts = {})

      # generate url with tags
      tags = normalize_tags opts
      url = build_url(tags)
      puts data(msg)
      post(url, data(msg))
      puts url
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
