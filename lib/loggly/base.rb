module Loggly
  class Base

    @@api_root = "http://logs-01.loggly.com"

    def initialize(token, opts = {})
      @token = token
      @opts = opts
      @tags = normalize_tags opts
      @client = AFMotion::Client.build @@api_root do
        request_serializer :json
        response_serializer :http
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
    def normalize_tags(hash, opts = {})
    
      # check for tags
      if hash.has_key? :tags
        if hash[:tags].kind_of?(Array)
          tags = hash[:tags]
        elsif hash[:tags].kind_of?(String)
          tags = [hash[:tags]]
        end
      else
        tags = []
      end

      # check for a single tag
      if hash.has_key?(:tag)
        tags << hash[:tag]
      end

      # merge tags with attributed tags
      if @tags and opts.has_key?(:object) and hash[:object]
        tags += @tags
      end 

      if hash.has_key?(:parent) and hash[:parent]
        tags += hash[:parent]
      end

      # remove duplicates
      return tags.uniq
    end

    def post(url, data, opts = {})

      @client.post url, data do |result|
        if result.success?
          if @cb
            Dispatch::Queue.current.async do
              @cb.call result
            end
         end
        else
          if opts.has_key? :retries
            if opts[:retries] > 0
              post(url, data, :retries => opts[:retries] - 1)
            else
              if @cb
                Dispatch::Queue.current.async do
                  @cb.call result
                end
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
