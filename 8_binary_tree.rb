# A tree is a data structure that allows us to represent different
# forms of hierarchical data. The DOM in HTML pages, files and folders
# in our disc, and the internal representation of Ruby programs are all
# different forms of data that can be represented using trees.
# The way we usually classify trees is by their branching factor,
# a number that describes how nodes multiply as we add more levels to the tree.
# Unsurprisingly, the branching factor of binary trees is two.
class BinaryTree
  # Represents a node in the binary tree.
  class Node
    # Initializes a new node with optional parent and data.
    #
    # @param parent [Node] The parent node.
    # @param data [Object] The data to be stored in the node.
    def initialize(parent, data = nil)
      @data = data
      @parent = parent
      @left = nil
      @right = nil
    end

    # Retrieves the data stored in the node.
    #
    # @return [Object] The data stored in the node.
    attr_reader :data

    # Retrieves or sets the parent node.
    #
    # @return [Node] The parent node.
    attr_accessor :parent

    # Retrieves or sets the left child node.
    #
    # @return [Node] The left child node.
    attr_accessor :left

    # Retrieves or sets the right child node.
    #
    # @return [Node] The right child node.
    attr_accessor :right
  end

  # Initializes a new binary tree with the given root node.
  #
  # @param root [Node] The root node of the binary tree.
  def initialize(root)
    @root = root
    @size = 1
  end

  # Retrieves the root node of the binary tree.
  #
  # @return [Node] The root node of the binary tree.
  attr_reader :root

  # Retrieves or sets the size of the binary tree.
  #
  # @return [Integer] The size of the binary tree.
  attr_accessor :size

  # Merges two binary trees into a new binary tree.
  #
  # @param tree1 [BinaryTree] The first binary tree to merge.
  # @param tree2 [BinaryTree] The second binary tree to merge.
  # @param data [Object] Optional data for the new root node.
  # @return [BinaryTree] The merged binary tree.
  def self.merge(tree1, tree2, data = nil)
    raise "Can't merge nil trees." unless tree1 && tree2

    root = Node.new(nil, data)
    res = BinaryTree.new(root)
    res.root.left = tree1.root
    res.root.right = tree2.root

    res.size = tree1.size + tree2.size
    res
  end

  # Inserts a new left child node with the given data to the specified node.
  #
  # @param node [Node] The node to which the left child will be inserted.
  # @param data [Object] The data for the new left child node.
  def insert_left(node, data)
    insert_node(node, data, :left)
  end

  # Inserts a new right child node with the given data to the specified node.
  #
  # @param node [Node] The node to which the right child will be inserted.
  # @param data [Object] The data for the new right child node.
  def insert_right(node, data)
    insert_node(node, data, :right)
  end

  # Removes the left child node and its descendants from the specified node.
  #
  # @param node [Node] The node from which the left child and its descendants will be removed.
  def remove_left(node)
    remove_node(node, :left)
  end

  # Removes the right child node and its descendants from the specified node.
  #
  # @param node [Node] The node from which the right child and its descendants will be removed.
  def remove_right(node)
    remove_node(node, :right)
  end

  # Prints the structure of the binary tree.
  def print
    print_rec(@root)
  end

  private

  # Inserts a new child node with the given data to the specified node and direction.
  #
  # @param node [Node] The node to which the child will be inserted.
  # @param data [Object] The data for the new child node.
  # @param direction [Symbol] The direction (:left or :right) in which to insert the child.
  def insert_node(node, data, direction)
    return unless node

    raise "Can't override nodes." if node.public_send(direction)

    @size += 1
    node.public_send("#{direction}=", Node.new(node, data))
  end

  # Removes the child node and its descendants from the specified node and direction.
  #
  # @param node [Node] The node from which the child and its descendants will be removed.
  # @param direction [Symbol] The direction (:left or :right) from which to remove the child.
  def remove_node(node, direction)
    return unless node

    while (next_node = node.send(direction))
      remove_node(next_node, direction)
      node.send("#{direction}=", nil)
      @size -= 1
      node = next_node
    end
  end

  # Recursively prints the structure of the binary tree starting from the specified node.
  #
  # @param node [Node] The node from which to start printing.
  # @param indent [Integer] The current indentation level for formatting.
  def print_rec(node, indent = 0)
    print_node(node, indent)

    print_rec(node.left, indent + 1) if node&.left
    print_rec(node.right, indent + 1) if node&.right
  end

  # Prints the data stored in the specified node with the given indentation level.
  #
  # @param node [Node] The node whose data will be printed.
  # @param indent [Integer] The indentation level for formatting.
  def print_node(node, indent)
    data = node&.data&.to_s || 'nil'
    puts data.rjust(indent * 4)
  end
end

# USAGE EXAMPLES

root1 = BinaryTree::Node.new(nil, 10)
tree1 = BinaryTree.new(root1)

# Inserting nodes to create a tree
node = root1
tree1.insert_left(node, 5)
tree1.insert_right(node, 15)
tree1.insert_left(node.left, 3)
tree1.insert_right(node.left, 7)
tree1.insert_left(node.right, 12)
tree1.insert_right(node.right, 18)

# Printing the initial tree
puts 'Initial tree structure:'
tree1.print

# Removing the left subtree of the root
node = root1
tree1.remove_left(node)

# Removing the right subtree of the root
tree1.remove_right(node)

# Printing the modified tree after removal
puts 'Modified tree structure after removing left and right subtrees of the root:'
tree1.print

root2 = BinaryTree::Node.new(nil, 20)
tree2 = BinaryTree.new(root2)
tree2.insert_left(root2, 17)
tree2.insert_right(root2, 25)

# Merging the two binary trees
merged_tree = BinaryTree.merge(tree1, tree2, 50)

# Printing the merged tree
puts 'Merged tree structure:'
merged_tree.print
