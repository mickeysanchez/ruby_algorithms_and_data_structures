def bsearch(array, target)
  return nil if array.empty?

  mid_index = array.count/2
  mid_element = array[mid_index]

  case mid_element <=> target
  when 0
    return mid_index

  when -1  # mid_element is smaller than target (target on right)
    sub_problem = bsearch(array[(mid_index + 1)..-1], target)

    if sub_problem
      mid_index + sub_problem
    else
      nil
    end

  when 1 # mid_element is larger than target (target on left)
    bsearch(array[0...mid_index], target)
  end
end

# take an array and an element
# return the index of the element or nil if it isn't found
# Hint: use subarrays

