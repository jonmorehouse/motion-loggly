module Loggly
  class Base

    @@api_root = "http://logs-01.loggly.com"

    def initialize(token, opts = {})
      @token = token
      @opts = opts
      @tags = normalize_tags opts
      @client = AFMotion::SessionClient.build @@api_root do
        session_configuration :ephemeral
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
    def normalize_msg(msg)

      if not msg.kind_of?(Hash)
        msg = {:msg => msg}
      end

      if not msg.has_key?(:timestamp)
        msg[:timestamp] = NSDate.new.string_with_format(:iso8601)
      end

      return msg

    end


    # return a list of unique tags 
    # opts {:tags => [], :tag => "", :object => false, :parent => {}}
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

    # hash {:url1 => msg1, :url2 => msg2}
    def post_from_hash(hash, opts = {}, &cb)

      queue = Dispatch::Queue.new("com.loggly.post_from_hash")
      results = []

      hash.each do |url, data|
        queue.async do
          s = Dispatch::Semaphore.new 0

          # note the afmotion is going to call the request asynchronously on the current thread, so wait for the completion
          @client.post(url, data) do |result|
            results.push(result)
            s.signal
          end
          s.wait
        end
      end

      # the callback should be called on the last called location
      current = Dispatch::Queue.current
      queue.barrier_async do
        current.async do
          cb.call(results)
        end
      end
    end


    def post(url, data, opts = {})
      @client.post url, data do |result|
        if @cb
          @cb.call(result)
        end
      end
    end
  end
end
