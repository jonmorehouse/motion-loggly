module Loggly 

  class Bulk < Base

    @endpoint = "bulk"
    class << self 
      attr_accessor :endpoint
    end

    # expects data to be an array of hashes
    def send(msgs, opts = {}, &cb)
      raise ArgumentError, "invalid method name" unless msgs.kind_of?(Array)
      queue = Dispatch::Queue.current
      cb = cb
      shared_tags = normalize_tags opts, object: true
      msgs = msgs.each do |msg|
        normalize_msg(msg)
      end

      # {[tags] => [msgs]
      tag_hash = parse_tags(msgs)
      request_hash = Hash.new

      # map tag_hash to a bunch of requests for post_from_hash to handle :)
      tag_hash.each do |tags, msgs|
        tags = tags + shared_tags.uniq
        url = build_url(tags)
        request_hash[url] = msgs
      end

      # make a bunch of post requests to submit the correct hashes to the server
      post_from_hash(request_hash) do |results|
        # return the callback on the correct method
        queue.async do
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
