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
