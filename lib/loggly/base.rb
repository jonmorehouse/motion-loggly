module LogglyAPI
  class Base

    @@api_root = "http://logs-01.loggly.com"
    @@endpoint = ""

    def initialize(token, opts = {})
      @token = token
      @opts = opts
      @tags = normalize_tags opts
    end

    def build_url(tags)

      pieces = [@@api_root, @@endpoint, @token].map do |piece|
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


    def post(url, data)

      # post to server


    end
  end
end
