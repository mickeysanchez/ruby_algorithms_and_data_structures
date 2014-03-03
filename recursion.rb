def range(start, finish)
  if start == finish
    [finish]
  else
    range(start, finish - 1) << finish
  end
end

def sum_iterative(arr)
  sum = 0
  arr.each { |el| sum += el }
  sum
end

def sum_recursive(arr)
  array = arr.dup
  return array.pop if array.length == 1
  array.pop + sum_recursive(array)
end

def exponentiation1(b, n)
  return 1 if n == 0
  p b * exponentiation1(b, n-1)
end

def exponentiation2(b, n)
  return 1 if n == 0
  p "b: #{b}"
  p "n: #{n}"
  if n.even?
    p exponentiation2(b, n/2) ** 2
  else
    p b * exponentiation2(b, (n-1) / 2) ** 2
  end
end