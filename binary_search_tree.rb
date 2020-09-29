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
    root = Node.new(arr[mid])
    root.prev_one = build_tree(arr, first, mid - 1)
    root.next_one = build_tree(arr, mid + 1, last)
    @root = root
  end

  def insert(value, temp)
    if temp.nil?
      temp = value
    elsif temp.<=>(value).positive?
      temp.prev_one = insert(value, temp.prev_one)
    elsif temp.<=>(value).negative?
      temp.next_one = insert(value, temp.next_one)
    end
    temp
  end

  def delete(value, temp)
    return temp if temp.nil?
    
    if temp.<=>(value).negative?
      temp.next_one = delete(value, temp.next_one)
    elsif temp.<=>(value).positive?
      temp.prev_one = delete(value, temp.prev_one)
    else
      if temp.prev_one.nil?
        return temp.next_one
      elsif temp.next_one.nil?
        return temp.prev_one
      end

      temp.value = min_value(temp.next_one)
      temp.next_one = delete(value, temp.next_one)
    end
    temp
  end

  def min_value(temp)
    minv = temp.value
    until temp.prev_one.nil?
      minv = temp.prev_one.value
      temp = temp.prev_one
    end
    minv
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.next_one, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.next_one
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.prev_one, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.prev_one
  end
end

numbers = [1, 2, 3, 4, 5, 6, 7]
tree = Tree.new(numbers)
tree.build_tree(tree.arr, 0, tree.arr.size - 1)

tree.insert(Node.new(8), tree.root)
tree.insert(Node.new(0), tree.root)
tree.delete(Node.new(4), tree.root)
tree.pretty_print
