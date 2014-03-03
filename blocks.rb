class Array
  def my_each
    i = 0
    while i < self.count
      yield self[i]
      i += 1
    end
    self
  end

  def my_map!
    i = 0
    while i < self.count
      self[i] = yield self[i]
      i += 1
    end
    self
  end

  def my_map(&prc)
    self.dup.my_map!(&prc)
  end

  def my_select
    new_arr = []
    self.my_each do |el|
      new_arr << el if yield el
    end
    new_arr
  end

  def my_inject
    accum = self.first
    i = 0
    while i < self.count
      accum = yield accum, self[i] unless i == 0
      i += 1
    end
    accum
  end

  def my_sort!
    sorted = false
    until sorted
      sorted = true

      i = 0
      while i < self.count
        break if i + 1 == self.count
        x = self[i]
        y = self[i + 1]
        block_given? ? comparison = yield(x, y) : comparison = x <=> y

        if comparison == 1
          self[i], self[i + 1] = self[i + 1], self[i]
          sorted = false
        end

        i += 1
      end
    end
    self
  end
end

def eval_block(*args, &blk)
  return puts "NO BLOCK GIVEN" unless block_given?
  blk.call(*args)
end