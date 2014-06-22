module Loggly
  class Base

    @@api_root = "http://logs-01.loggly.com"

    def initialize(token, opts = {})
      @token = token
      @opts = opts
      @tags = normalize_tags opts
      @queue = Dispatch::Queue.new("com.motion-loggly")
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

      queue = Dispatch::Queue.new("com.loggly.post")
      results = []

      # make each request
      hash.each do |url, data|
        s = Dispatch::Semaphore.new 0

        # note the afmotion is going to call the request asynchronously on the current thread, so wait for the completion
        post(url, data) do |result|
          results.push(result)
          s.signal
        end

        # wait for the async afmotion call to finish
        s.wait
      end

      # the callback should be called on the last called location
      current = Dispatch::Queue.current
      queue.barrier_async do
        # hop on the correct location and pass the results to the correct block
        current.async do
          cb.call(results)
        end
      end
    end


    def post(url, data, opts = {})

      @client.post url, data do |result|
        if result.success?
          if @cb
            Dispatch::Queue.current.async do
              @cb.call result
            end
         end
        else # handle errors
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
