module Loggly 

  class Bulk < Base

    @endpoint = "bulk"
    class << self 
      attr_accessor :endpoint
    end

    # expects data to be an array of hashes
    def send(msgs, opts = {}, &cb)
      raise ArgumentError, "invalid method name" unless msgs.kind_of?(Array)
      cb = cb
      shared_tags = normalize_tags opts, object: true
      tag_hash = parse_tags(msgs)
      current = Dispatch::Queue.current

      # client
      client = AFMotion::SessionClient.build "http://www.espn.com", do |c|
        c.session_configuration :ephemeral
        #c.request_serializer :json
        c.response_serializer :http
      end

      q = Dispatch::Queue.new("test")
      results = []

      tag_hash.each do |tags, msgs|
        # grab the tags for this particular instance 
        tags = (tags + shared_tags).uniq

        # generate the request and do it on the side thread
        q.async do
          url = build_url(tags)
          s = Dispatch::Semaphore.new 0

          client.get("nfl") do |result|
            puts "\n"
            puts result.success?
            s.signal
          end
          
          s.wait
        end 
      end

      q.barrier_async do
        # call the callback on the thread that called this method
        current.async do
          cb.call(results)
        end
      end
    end

    def parse_tags(msgs)

      # create a hash of each unique message, where tags are joined by comma
      map = Hash.new
      msgs.each do |msg|
        if not msg.kind_of?(Hash)
          msg = {:msg => msg, :tags => []}
        end
        msg[:timestamp] ||= NSDate.new.string_with_format(:iso8601)
        tags = normalize_tags(msg).map do |x|
          x.to_s 
        end

        # delete unneeded keys
        [:tag, :tags].each do |key|
           msg.delete key
        end

        # set message on the hash
        if not map.has_key?(tags[0])
          map[tags] = []
        end
        map[tags].push msg
      end
      return map
    end

  end
end
