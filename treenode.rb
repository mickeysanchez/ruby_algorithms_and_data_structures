# Here we visit a node, then each of its def children(args)
# endthen each of their children, etc. An advantage of breadth-def first(args)
# endsearch is that it considers shallower nodes before deeper ones.

# TreeNode which represents a node in a binary tree.
# every node should be instance of TreeNode

# T.remove_child(somechild)

#    t = TreeNode.new(value)
#    t2 = Treenode.new(value2)
#    t.remove_child(t2)
###      iterate over all @children from t and see if any matches t2.value

class TreeNode

  attr_accessor :value, :parent, :children

  def initialize(value)
    @parent = nil
    @children = []
    @value = value
  end

  def remove_child(child_node)
    @children.each_with_index do |child, index|
      if child == child_node
        child_node.parent = nil
        return @children.delete_at(index)
      end
    end
    puts "child node doesn't exist"
  end

  def add_child(new_child)
    new_child.parent.children.delete(new_child) unless new_child.parent.nil?
    new_child.parent = self
    @children << new_child
  end


  # Each time, we try to visit the left
 #   if it exists and hasn't been visited yet
 #    If it has, we try to visit the right child
 # if it exists and hasn't been visited yet
 # If all the children have been visited, then we move up one level and repeat.




  def dfs(target)
    # self is the node: base case
    return self if self.value == target
    # return nil if self.children[0].nil?

    self.children.each do |child|
      # result = child.dfs(target)
      return child.dfs(target) unless child.dfs(target).nil?
    end

    nil
  end


  def bfs(target)
    array = []
    array << self
    until array.empty?
      current_node = array.shift
      return current_node if current_node.value == target
      array += current_node.children unless current_node.children.empty?
    end
    nil
  end
end


t1 = TreeNode.new([1,2])
t2 = TreeNode.new([3,5])
t3 = TreeNode.new([5,6])
t4 = TreeNode.new([8,8])
t5 = TreeNode.new([2,8])
t6 = TreeNode.new([5,6])
t7 = TreeNode.new([2,4])
t8 = TreeNode.new(8)
t9 = TreeNode.new(9)
t10 = TreeNode.new(10)

# t1.add_child(t2)
# t2.add_child(t3)
# t3.add_child(t4)
# t1.add_child(t5)
# t5.add_child(t6)
# t6.add_child(t7)
# t6.add_child(t8)
# t5.add_child(t9)

t1.add_child(t2)
t1.add_child(t3)
t2.add_child(t4)
t3.add_child(t5)
t3.add_child(t6)
t4.add_child(t7)
t5.add_child(t8)
t5.add_child(t9)
# t9.add_child(t8)

# 1.upto(10) do |i|
  # p t9.bfs(8).value
# end

# p t1.bfs(2).value