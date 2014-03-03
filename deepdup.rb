def deep_dup(arr)
  duped_array = []
  arr.each do |el|
    if el.is_a? Array
      duped_array << deep_dup(el)
    else
      temp_array = []
      temp_array << el.dup unless el.is_a?(Integer)
      duped_array += temp_array
    end
  end
  duped_array
end