# A singly linked list is a data structure that
# allows us to manage variable-sized collections of elements.
class SinglyLinkedList
  # Node represents an element in the singly linked list.
  class Node
    # Initializes a new node with the given data.
    #
    # @param data [Object] The data to be stored in the node.
    def initialize(data)
      @data = data
      @next = nil
    end

    attr_accessor :next
    attr_reader :data
  end

  # Initializes an empty singly linked list.
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

    if @head
      @tail.next = node
    else
      @head = node
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

    succeed = false
    if node == @head
      if @head.next.nil?
        @head = @tail = nil
      else
        @head = @head.next
      end
      succeed = true
    else
      tmp = @head
      tmp = tmp.next while tmp && tmp.next != node
      if tmp
        succeed = true
        tmp.next = node.next
      end
    end

    @length -= 1 if succeed
  end

  # Concatenates another singly linked list to the end of this list.
  #
  # @param list [SinglyLinkedList] The list to be concatenated.
  def cat(list)
    return unless list
    return unless list.length > 0

    if @head.nil?
      @head = list.head
    else
      @tail.next = list.head
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

  # Prints the data of each node in the list.
  def print
    return unless @length > 0

    each do |node|
      puts node.data
    end
  end
end

# USAGE EXAMPLES

# Create a new singly linked list
list1 = SinglyLinkedList.new

# Insert some elements into the list
list1.insert(1)
list1.insert(2)
list1.insert(3)

# Output the current list
puts 'List 1:'
list1.print
# Output:
# 1
# 2
# 3

# Create another singly linked list
list2 = SinglyLinkedList.new

# Insert elements into the second list
list2.insert(4)
list2.insert(5)

# Output the second list
puts 'List 2:'
list2.print
# Output:
# 4
# 5

# Concatenate the second list to the first list
list1.cat(list2)

# Output the first list after concatenation
puts 'Concatenated List:'
list1.print
# Output:
# 1
# 2
# 3
# 4
# 5

# Remove an element from the concatenated list
list1.remove(list1.find_first { |node| node.data == 3 })

# Output the concatenated list after removal
puts 'Concatenated List after Removal:'
list1.print
# Output:
# 1
# 2
# 4
# 5

# Check if the concatenated list includes a certain element
puts "Includes 4? #{list1.includes?(4)}" # Output: true

# Clear the concatenated list
list1.clear

# Output the concatenated list after clearing
puts 'Concatenated List after Clearing:'
list1.print
# Output: (Nothing will be printed as the list is empty)
