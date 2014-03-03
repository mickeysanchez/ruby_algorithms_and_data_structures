def merge_sort(arr)
  subarrays = arr.map { |el| [el] }

  until subarrays.length == 1
    0.upto((subarrays.length-2)) do |i|
        p subarrays
        subarrays << merge(subarrays[i], subarrays[i+1])
    end
  end

  subarrays[0]
end

def merge(arr1, arr2)
  merged_array = []
  
  until arr1.empty? || arr2.empty?
    if arr1.first < arr2.first
      merged_array << arr1.shift
    else
      merged_array << arr2.shift
    end
  end
  
  merged_array + arr1 + arr2
end
