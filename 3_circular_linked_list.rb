# Circular linked lists are named after the circular pattern that shows up when
# we run traversals on them. Since this kind of lists have no tail, traversals
# wraparound at the last element and restart from the head of the list forming a circle.
class CircularLinkedList
  # Represents an element in the circular linked list.
  class Node
    # Initializes a new node with the given data.
    #
    # @param data [Object] The data to be stored in the node.
    def initialize(data)
      @data = data
      @next = nil
      @prev = nil
    end

    # @return [Object] The data stored in the node.
    attr_reader :data

    # @return [Node, nil] The next node in the list.
    attr_accessor :next

    # @return [Node, nil] The previous node in the list.
    attr_accessor :prev
  end

  # Initializes an empty circular linked list.
  def initialize
    @head = nil
    @length = 0
  end

  # @return [Node, nil] The head node of the list.
  attr_reader :head

  # @return [Integer] The number of nodes in the list.
  attr_reader :length

  # Inserts a new node with the given data into the list.
  #
  # @param data [Object] The data to be inserted.
  def insert(data)
    return insert_next(nil, data) if @length == 0
    return insert_next(@head, data) if @length == 1

    @current = @head
    i = 0
    move_next while (i += 1) < @length

    insert_next(@current, data)
  end

  # Inserts a new node with the given data after the specified node.
  #
  # @param prev [Node, nil] The node after which the new node will be inserted.
  #                         If nil, the new node will be inserted at the beginning of the list.
  # @param data [Object] The data to be inserted.
  def insert_next(prev, data)
    new_node = Node.new(data)

    if @length == 0
      @head = new_node.next = new_node.prev = new_node
    elsif prev.nil?
      new_node.next = @head
      new_node.prev = @head.prev
      @head.prev.next = new_node
      @head.prev = new_node
      @head = new_node
    else
      new_node.next = prev.next
      new_node.prev = prev
      prev.next = new_node
      new_node.next.prev = new_node if new_node.next
    end

    @length += 1
  end

  # Removes the specified node from the list.
  #
  # @param node [Node] The node to be removed.
  def remove(node)
    return unless node
    return unless @length > 0
    return remove_next(@head.next) if @head == node

    prev = nil
    found = false
    full_scan do |nd|
      if nd == node
        found = true
        break
      end
      prev = nd
    end

    remove_next(prev) if found
  end

  # Removes the node following the specified node from the list.
  #
  # @param prev [Node, nil] The node before the node to be removed.
  #                         If nil, the head node will be removed.
  def remove_next(prev)
    return unless @length > 0

    if prev
      if prev.next == prev
        @head = nil
      else
        old = prev.next
        prev.next = prev.next&.next
        @head = old.next if old == @head
      end
    else
      @head = @head.next
    end

    @length -= 1
  end

  # Removes all nodes from the list.
  def clear
    remove(@head) while @length > 0
  end

  # Checks if the list includes a node containing the specified data.
  #
  # @param data [Object] The data to search for.
  # @return [Boolean] True if the data is found, false otherwise.
  def includes?(data)
    return false unless @length > 0

    @current = @head
    loop do
      return true if @current.data == data
      return false if move_next == @head
    end
  end

  # Moves to the next node in the list.
  #
  # @return [Node, nil] The next node in the list.
  def move_next
    @current = @current&.next
  end

  # Iterates over each node in the list.
  #
  # @yield [Node] The block to be executed for each node.
  def full_scan
    return unless block_given?
    return unless @length > 0

    @current = @head
    loop do
      yield @current
      break if move_next == @head
    end
  end

  # Finds the first node in the list that satisfies the given predicate.
  #
  # @yield [Node] The block to be executed for each node.
  # @return [Node, nil] The first node that satisfies the predicate, or nil if none is found.
  def find_first(&predicate)
    return unless block_given?
    return unless @length > 0

    @current = @head
    loop do
      return @current if predicate.call(@current)

      break if move_next == @head
    end
  end

  # Prints the data of each node in the list.
  def print
    return if @length == 0

    full_scan do |item|
      puts item.data
    end
  end
end

# USAGE EXAMPLES

# Create a new circular linked list
list = CircularLinkedList.new

# Insert some elements into the list
list.insert(1)
list.insert(2)
list.insert(3)

# Output the current list
puts 'List:'
list.print
# Output:
# 1
# 2
# 3

# Check if the list includes a certain element
puts "Includes 2? #{list.includes?(2)}" # Output: true

# Find the first node in the list that satisfies a predicate
first_node = list.find_first { |node| node.data > 1 }
puts 'First Node with Data > 1:'
puts first_node.data # Output: 2

# Remove a node from the list
list.remove(first_node)

# Output the list after removal
puts 'List after Removal:'
list.print
# Output:
# 1
# 3

# Insert an element into the list using insert_next
list.insert_next(nil, 4)

# Output the list after insertion
puts 'List after Insertion:'
list.print
# Output:
# 4
# 1
# 3

# Insert another element after the first one
list.insert_next(list.head, 5)

# Output the list after insertion
puts 'List after Insertion:'
list.print
# Output:
# 4
# 5
# 1
# 3

# Remove the second node from the list using remove_next
list.remove_next(list.head)

# Output the list after removal
puts 'List after Removal:'
list.print
# Output:
# 4
# 1
# 3

# Clear the list
list.clear

# Output the list after clearing
puts 'List after Clearing:'
list.print
# Output: (Nothing will be printed as the list is empty)
