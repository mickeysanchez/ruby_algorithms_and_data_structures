def fib(n)
  return [] if n == 0
  return [0] if n == 1

  base_fibs = [0, 1]

  until base_fibs.count == n
    base_fibs << (base_fibs[-1] + base_fibs[-2])
  end

  base_fibs
end

def fib_rec(n)
  case n
  when 0
    []
  when 1
    [0]
  when 2
    [0,1]
  else
    fib_rec(n-1) << (fib_rec(n-1).last + fib_rec(n-2).last)
  end
end


