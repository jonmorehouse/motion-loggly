module LogglyAPI
  class Base

    @@api_root = "http://logs-01.loggly.com"

    def initialize(token, opts = {})
      @token = token
      @opts = opts
      @tags = normalize_tags opts
      @client = AFMotion::Client.build(@@api_root) do
        response_serializer :json
        request_serializer :json
      end
    end

    def build_url(tags)

      pieces = [self.class.endpoint, @token].map do |piece|
        piece.rstrip()
      end

      # add in tags field, this is a combination of classwide and message tags
      if tags.length > 0
        pieces << "tag" << tags.join(",")
      end

      return pieces.join("/")
    end

    protected
    def normalize_tags(opts = {})
    
      # check for tags
      if opts.has_key? :tags
        if opts[:tags].kind_of?(Array)
          tags = opts[:tags]
        elsif opts[:tags].kind_of?(String)
          tags = [opts[:tags]]
        end
      else
        tags = []
      end

      # check for a single tag
      if opts.has_key? :tag
        tags << opts[:tag]
      end

      # merge tags with attributed tags
      if @tags
        tags += @tags
      end 

      # remove duplicates
      return tags.uniq
    end

    def post(url, data, opts = {})
      @client.post(url, data) do |result|
        # handle errors
        if result.success?
          if @cb
            @cb.call result
          end
        else
          if opts.has_key? :retries
            if opts[:retries] > 0
              post(url, data, :retries => opts[:retries] - 1)
            else
              if @cb
                @cb.call result
              end
            end
          else
            post(url, data, :retries => 5)   
          end
        end
      end
    end

  end
end
