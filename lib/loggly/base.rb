module LogglyAPI
  class Base

    @@api_root = "http://logs-01.loggly.com"

    def initialize(token, opts = {})
      @token = token
      @opts = opts
      @tags = normalize_tags opts
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

      if data.kind_of?(Array)
        data = stringify_array(data)        
      else
        data = stringify_hash(data)
      end

      AFMotion::HTTP.post("#{@@api_root}/#{url}", data) do |result|

        @cb.call(result)
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

    def stringify_hash(input)
      output = Hash.new
      input.each do |key, value|
        output[key.to_s] = value 
      end
      return output
    end

    def stringify_array(input)

      output = []
      input.each do |piece|

        if piece.kind_of?(Array)
          piece = stringify_array(piece)
        elsif piece.kind_of?(Hash)
          piece = stringify_hash(piece)
        elsif piece.respond_to?("to_s")
          piece = piece.to_s  
        else
          piece = piece
        end
        # add piece to output
        output << piece
      end
      return output

    end

  end
end
