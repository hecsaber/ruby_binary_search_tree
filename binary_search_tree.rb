class Node
  include Comparable
  attr_accessor :prev_one, :value, :next_one

  def <=>(other)
    value <=> other.value
  end

  def initialize(value)
    @prev_one = nil
    @value = value
    @next_one = nil
  end
end

class Tree
  attr_accessor :arr, :root

  def initialize(arr)
    @arr = arr.uniq.sort
  end

  def build_tree(arr, first, last)
    return nil if first > last

    mid = (first + last) / 2
    node = Node.new(arr[mid])
    node.prev_one = build_tree(arr, first, mid - 1)
    node.next_one = build_tree(arr, mid + 1, last)
    @root = node
  end

  def insert(value, node)
    if node.nil?
      node = value
    elsif node.<=>(value).positive?
      node.prev_one = insert(value, node.prev_one)
    elsif node.<=>(value).negative?
      node.next_one = insert(value, node.next_one)
    end
    node
  end

  def delete(value, node)
    return node if node.nil?
    
    if node.<=>(value).negative?
      node.next_one = delete(value, node.next_one)
    elsif node.<=>(value).positive?
      node.prev_one = delete(value, node.prev_one)
    else
      if node.prev_one.nil?
        return node.next_one
      elsif node.next_one.nil?
        return node.prev_one
      end

      min_node = min_value(node.next_one)
      node.value = min_node.value
      node.next_one = delete(min_node, node.next_one)
    end
    node
  end

  def min_value(node)
    minv = node
    until node.prev_one.nil?
      minv = node.prev_one
      node = node.prev_one
    end
    minv
  end

  def find(value, node)
    return nil if node.nil?
    return node if value.eql? node.value

    if value < node.value
      node.prev_one = find(value, node.prev_one)
    elsif value > node.value
      node.next_one = find(value, node.next_one)
    end
  end

  def level_order
    queue = []
    res = []
    queue << root
    until queue.empty?
      current = queue.first
      res << current.value
      queue << current.prev_one unless current.prev_one.nil?
      queue << current.next_one unless current.next_one.nil?
      queue.shift
    end
    res
  end

  def inorder(node, res = [])
    return if node.nil?

    inorder(node.prev_one, res)
    res << node.value
    inorder(node.next_one, res)
    res
  end

  def preorder(node, res = [])
    return if node.nil?

    res << node.value
    preorder(node.prev_one, res)
    preorder(node.next_one, res)
    res
  end

  def postorder(node, res = [])
    return if node.nil?

    postorder(node.prev_one, res)
    postorder(node.next_one, res)
    res << node.value
    res
  end

  def height(node)
    return 0 if node.nil?

    left_height = height(node.prev_one)
    right_height = height(node.next_one)
    1 + [left_height, right_height].max
  end

  def depth(node)
    return -1 if node.nil?

    left_depth = depth(node.prev_one)
    right_depth = depth(node.next_one)
    if left_depth > right_depth
      left_depth + 1
    else
      right_depth + 1
    end
  end

  def balanced?(node)
    return true if node.nil?

    lh = height(node.prev_one)
    rh = height(node.next_one)

    return true if (lh - rh).abs <= 1 && balanced?(node.prev_one) && balanced?(node.next_one)
    
    false
  end

  def rebalance(node)
    return node if balanced?(node)
    new_array = level_order.uniq.sort
    build_tree(new_array, 0, new_array.size - 1)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.next_one, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.next_one
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.prev_one, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.prev_one
  end
end

my_array = Array.new(15) { rand(1..100) }
tree = Tree.new(my_array)
tree.build_tree(tree.arr, 0, tree.arr.size - 1)
p tree.balanced?(tree.root)
p tree.level_order
p tree.preorder(tree.root)
p tree.inorder(tree.root)
p tree.postorder(tree.root)
tree.insert(Node.new(105), tree.root)
tree.insert(Node.new(120), tree.root)
p tree.balanced?(tree.root)
tree.rebalance(tree.root)
p tree.balanced?(tree.root)
p tree.level_order
p tree.preorder(tree.root)
p tree.inorder(tree.root)
p tree.postorder(tree.root)
