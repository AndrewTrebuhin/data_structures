# A doubly linked list is a member of the linked list
# family where each node is connected by two pointers.
# The main difference with singly linked lists is that
# in doubly linked traversals are bidirectional and removals
# run in constant time. These features are possible because each
# node has a pointer to the previous and next node in the list.
class DoublyLinkedList
  # Node represents an element in the doubly linked list.
  class Node
    # Initializes a new node with the given data.
    #
    # @param data [Object] The data to be stored in the node.
    def initialize(data)
      @data = data
      @prev = nil
      @next = nil
    end

    attr_reader :data
    attr_accessor :prev, :next
  end

  # Initializes an empty doubly linked list.
  def initialize
    @head = nil
    @tail = nil
    @length = 0
  end

  attr_reader :head, :tail, :length

  # Inserts a new node with the given data at the end of the list.
  #
  # @param data [Object] The data to be inserted into the list.
  def insert(data)
    node = Node.new(data)

    if @head.nil?
      @head = node
    else
      node.prev = @tail
      @tail.next = node
    end

    @tail = node
    @length += 1
  end

  # Removes the specified node from the list.
  #
  # @param node [Node] The node to be removed.
  def remove(node)
    return unless node
    return unless @length > 0

    if node == @head
      if @head.next.nil?
        @head = @tail = nil
      else
        @head = @head.next
        @head.prev = nil
      end
    elsif node == @tail
      @tail = @tail.prev
      @tail.next = nil
    else
      p = node.prev
      n = node.next
      p&.next = n
      n&.prev = p
    end

    @length -= 1
  end

  # Concatenates another doubly linked list to the end of this list.
  #
  # @param list [DoublyLinkedList] The list to be concatenated.
  def cat(list)
    return unless list
    return unless list.length > 0

    if @tail
      list.head.prev = @tail
      @tail.next = list.head
    else
      @head = list.head
    end

    @tail = list.tail
    @length += list.length
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

    current = @head
    while current
      return true if current.data == data

      current = current.next
    end
    false
  end

  # Finds the first node that satisfies the given predicate.
  #
  # @yield [Node] The block to be executed for each node.
  # @return [Node, nil] The first node that satisfies the predicate, or nil if none is found.
  def find_first(&predicate)
    return unless block_given?
    return unless @length > 0

    current = @head
    while current
      return current if predicate.call(current)

      current = current.next
    end
  end

  # Finds the last node that satisfies the given predicate.
  #
  # @yield [Node] The block to be executed for each node.
  # @return [Node, nil] The last node that satisfies the predicate, or nil if none is found.
  def find_last(&predicate)
    return unless block_given?
    return unless @length > 0

    current = @tail
    while current
      return current if predicate.call(current)

      current = current.prev
    end
  end

  # Iterates over each node in the list.
  #
  # @yield [Node] The block to be executed for each node.
  def each
    return unless block_given?
    return unless @length > 0

    current = @head
    while current
      yield current
      current = current.next
    end
  end

  # Iterates over each node in the list in reverse order.
  #
  # @yield [Node] The block to be executed for each node.
  def reverse_each
    return unless block_given?
    return unless @length > 0

    current = @tail
    while current
      yield current
      current = current.prev
    end
  end

  # Prints the data of each node in the list.
  def print
    return unless @length > 0

    each do |node|
      puts node.data
    end
  end

  # Prints the data of each node in the list in reverse order.
  def reverse_print
    return unless @length > 0

    reverse_each do |node|
      puts node.data
    end
  end
end

# USAGE EXAMPLES

# Create a new doubly linked list
list = DoublyLinkedList.new

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

# Create another doubly linked list
other_list = DoublyLinkedList.new

# Insert elements into the second list
other_list.insert(4)
other_list.insert(5)

# Output the second list
puts 'Other List:'
other_list.print
# Output:
# 4
# 5

# Concatenate the second list to the first list
list.cat(other_list)

# Output the first list after concatenation
puts 'Concatenated List:'
list.print
# Output:
# 1
# 2
# 3
# 4
# 5

# Check if the concatenated list includes a certain element
puts "Includes 2? #{list.includes?(2)}" # Output: true

# Find the first node in the concatenated list that satisfies a predicate
first_node = list.find_first { |node| node.data > 2 }
puts 'First Node with Data > 2:'
puts first_node.data # Output: 3

# Find the last node in the concatenated list that satisfies a predicate
last_node = list.find_last { |node| node.data < 4 }
puts 'Last Node with Data < 4:'
puts last_node.data # Output: 3

# Output the concatenated list in reverse order
puts 'Reverse Printed List:'
list.reverse_print
# Output:
# 5
# 4
# 3
# 2
# 1

# Remove a node from the concatenated list
list.remove(first_node)

# Output the concatenated list after removal
puts 'List after Removal:'
list.print
# Output:
# 1
# 2
# 4
# 5

# Clear the concatenated list
list.clear

# Output the concatenated list after clearing
puts 'List after Clearing:'
list.print
# Output: (Nothing will be printed as the list is empty)
