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

  def dfs(target)
    return self if self.value == target


    self.children.each do |child|
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

  def path
    return [] if self.parent.nil?
    node = self
    path_array = []
    path_array.unshift(node.value)
    until node.parent.nil?

      path_array.unshift(node.parent.value)

      node = node.parent
    end
    path_array
  end

end

class KnightPathFinder

  attr_reader :start_node

  def initialize(start_coordinates)
    @start_node = TreeNode.new(start_coordinates)
    build_move_tree
  end

  def build_move_tree
    positions_to_visit = [@start_node] # TreeNode
    been_there = []

    until positions_to_visit.empty?
      position = positions_to_visit.shift # TreeNode

      possible_moves = new_move_positions(position)

      possible_moves.each do |move|
        positions_to_visit << move unless been_there.include?(move.value)
        been_there << move.value unless been_there.include?(move.value)
      end
    end
  end

  def new_move_positions(node)
    possibles = [[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1],[-2,1],[1,2],[-1,2]]

    poss_nodes = []

    possibles.each do |move_pair|
      x_move = move_pair[0]
      y_move = move_pair[1]
      if valid?([node.value[0] + x_move, node.value[1] + y_move])
        poss_node = TreeNode.new([node.value[0] + x_move, node.value[1] + y_move])
        node.add_child(poss_node)
        poss_nodes << poss_node # shovel node into array
      end
    end
    poss_nodes
  end

  def find_path(target_pos)
    @start_node.bfs(target_pos).path
  end

  def valid?(move)
    (move[0] >= 0 && move[0] <= 8) && (move[1] >= 0 && move[1] <= 8)
  end

end

k = KnightPathFinder.new([0,0])
# k.new_move_positions(k.start_position)
# k.start_position.children.each {|i| p i.value}

# p k.start_node.children.count

p k.find_path([3,3])