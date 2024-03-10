# Binary search tree, or BTS for short, is a variation of a binary tree
# data structure designed to perform fast lookups on large datasets.
# The subject of this chapter is AVL trees, a special kind of self-balancing
# BST named after its creators Adelson-Velskii and Landis.
# On AVL trees nodes arranged in descendant order, and the height difference
# between the left and right subtrees (the balance factor) is always -1, 0 or 1.
# As it happens with sets, AVL trees can't contain duplicate keys.
class AVLTree
  # Represents a node in the AVL tree.
  class Node
    # Initializes a new node with the given key and data.
    #
    # @param key [Integer] The key of the node.
    # @param data [Object] The data associated with the node.
    def initialize(key, data)
      @key = key
      @data = data
      @height = 1
    end

    # @return [Object] The data stored in the node.
    attr_accessor :data

    # @return [Integer] The key of the node.
    attr_accessor :key

    # @return [Integer] The height of the node in the tree.
    attr_accessor :height

    # @return [Node, nil] The left child of the node.
    attr_accessor :left

    # @return [Node, nil] The right child of the node.
    attr_accessor :right

    # @return [Boolean] Indicates if the node has been marked as deleted.
    attr_accessor :deleted
  end

  # Inserts a new node with the given key and optional data into the AVL tree.
  #
  # @param key [Integer] The key of the node to be inserted.
  # @param data [Object, nil] The optional data to be associated with the node.
  def insert(key, data = nil)
    return unless key

    ensure_int(key)
    @root = insert_and_balance(@root, key, data)
  end

  # Marks the node with the given key as deleted in the AVL tree.
  #
  # @param key [Integer] The key of the node to be marked as deleted.
  def remove(key)
    return unless key

    search(key)&.deleted = true
  end

  # Searches for a node with the given key in the AVL tree.
  #
  # @param key [Integer] The key of the node to search for.
  # @return [Node, nil] The node with the given key if found, otherwise nil.
  def search(key)
    return unless key

    node = search_rec(@root, key)
    node unless node&.deleted
  end

  # Prints the AVL tree structure.
  def print
    print_rec(@root, 0)
  end

  private

  # Calculates the height of the given node.
  #
  # @param node [Node] The node whose height is to be calculated.
  # @return [Integer] The height of the node.
  def h(node)
    node&.height || 0
  end

  # Inserts a new node with the given key and optional data into the AVL tree
  # and performs the necessary rebalancing operations.
  #
  # @param node [Node] The current node being processed.
  # @param key [Integer] The key of the node to be inserted.
  # @param data [Object, nil] The optional data to be associated with the node.
  # @return [Node] The updated node after insertion and rebalancing.
  def insert_and_balance(node, key, data = nil)
    return Node.new(key, data) unless node

    if key < node.key
      node.left = insert_and_balance(node.left, key, data)
    elsif key > node.key
      node.right = insert_and_balance(node.right, key, data)
    else
      node.data = data
      node.deleted = false
    end
    balance(node)
  end

  # Balances the AVL tree by performing rotations if necessary.
  #
  # @param n [Node] The current node being balanced.
  # @return [Node] The balanced node.
  def balance(n)
    set_height(n)

    if h(n.left) - h(n.right) == 2
      return rotate_left_right(n) if h(n.left.right) > h(n.left.left)

      return rotate_right(n)
    elsif h(n.right) - h(n.left) == 2
      return rotate_right_left(n) if h(n.right.left) > h(n.right.right)

      return rotate_left(n)
    end

    n
  end

  # Recursively searches for a node with the given key in the AVL tree.
  #
  # @param node [Node] The current node being processed.
  # @param key [Integer] The key of the node to search for.
  # @return [Node, nil] The node with the given key if found, otherwise nil.
  def search_rec(node, key)
    return nil unless node
    return search_rec(node.left, key) if key < node.key
    return search_rec(node.right, key) if key > node.key

    node
  end

  # Sets the height of the given node based on the heights of its children.
  #
  # @param node [Node] The node whose height is to be updated.
  def set_height(node)
    lh = h(node&.left)
    rh = h(node&.right)
    max = lh > rh ? lh : rh
    node.height = 1 + max
  end


  # Performs a right rotation on the given node.
  #
  # @param node [Node] The node to perform the rotation on.
  # @return [Node] The new root node after rotation.
  def rotate_right(node)
    new_root = node.left
    node.left = new_root.right
    new_root.right = node
    set_height(node)
    set_height(new_root)

    new_root
  end

  # Performs a left rotation on the given node.
  #
  # @param node [Node] The node to perform the rotation on.
  # @return [Node] The new root node after rotation.
  def rotate_left(node)
    new_root = node.right
    node.right = new_root.left
    new_root.left = node
    set_height(node)
    set_height(new_root)

    new_root
  end

  # Performs a left-right rotation on the given node.
  #
  # @param node [Node] The node to perform the rotation on.
  # @return [Node] The new root node after rotation.
  def rotate_left_right(node)
    node.left = rotate_left(node.left)

    rotate_right(node)
  end

  # Performs a right-left rotation on the given node.
  #
  # @param node [Node] The node to perform the rotation on.
  # @return [Node] The new root node after rotation.
  def rotate_right_left(node)
    node.right = rotate_right(node.right)

    rotate_left(node)
  end

  # Recursively prints the AVL tree structure starting from the given node.
  #
  # @param node [Node] The current node being processed.
  # @param indent [Integer] The current indentation level.
  def print_rec(node, indent)
    unless node
      puts 'x'.rjust((indent + 1) * 4, ' ')
      return
    end

    puts_key(node, indent)
    print_rec(node.left, indent + 1)
    print_rec(node.right, indent + 1)
  end

  # Prints the key of the given node with appropriate indentation.
  #
  # @param node [Node] The node to print.
  # @param indent [Integer] The current indentation level.
  def puts_key(node, indent)
    txt = node.key.to_s
    if node.deleted
      txt += ' (D)'
      puts txt.rjust((indent + 1) * 8, ' ')
    else
      puts txt.rjust((indent + 1) * 4, ' ')
    end
  end

  # Ensures that the key is an Integer and raises an error if not.
  #
  # @param key [Object] The key to validate.
  # @raise [TypeError] If the key is not an Integer.
  def ensure_int(key)
    return if key.is_a?(Integer)

    raise "Can't use objects of type #{key.class} as keys. Use Integer instead."
  end
end

# USAGE EXAMPLES

# Create an AVL tree
tree = AVLTree.new

# Insert some nodes
tree.insert(10)
tree.insert(20)
tree.insert(5)

# Print the tree
puts 'AVL Tree after insertion:'
tree.print

# Remove a node
tree.remove(10)

# Search for a node
node = tree.search(20)
puts "Node found with key: #{node&.key}"

# Print the tree after removal
puts 'AVL Tree after removal:'
tree.print
