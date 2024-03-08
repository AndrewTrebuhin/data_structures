# A stack is a special kind of singly linked list designed to efficiently
# store and retrieve elements in last in,first out basis (LIFO).
class Stack
  # Represents an element in the stack.
  class Node
    # Initializes a new node with the given data.
    #
    # @param data [Object] The data to be stored in the node.
    def initialize(data)
      @data = data
      @next = nil
    end

    # @return [Object] The data stored in the node.
    attr_reader :data

    # @return [Node, nil] The next node in the stack.
    attr_accessor :next
  end

  # Initializes a new empty stack.
  def initialize
    @head = nil
    @tail = nil
    @length = 0
  end

  # Adds an element to the top of the stack.
  #
  # @param data [Object] The data to be pushed onto the stack.
  def push(data)
    node = Node.new(data)

    @tail = node if @length == 0

    node.next = @head
    @head = node
    @length += 1
  end

  # Removes and returns the top element of the stack.
  #
  # @return [Node, nil] The top element of the stack, or nil if the stack is empty.
  def pop
    return unless @length > 0

    @head = @head.next
    @tail = nil if @length == 1
    @length -= 1
  end

  # Returns the top element of the stack without removing it.
  #
  # @return [Node, nil] The top element of the stack, or nil if the stack is empty.
  def peek
    @head
  end

  # Returns the size of the stack.
  #
  # @return [Integer] The number of elements in the stack.
  def size
    @length
  end

  # Removes all elements from the stack.
  def clear
    pop while peek
  end

  # Prints all elements in the stack.
  def print
    return if @length == 0

    current = @head
    while current
      puts current.data

      current = current.next
    end
  end
end

# USAGE EXAMPLES

# Creating a new instance of Stack
stack = Stack.new

# Pushing elements onto the stack
stack.push(5)
stack.push(10)
stack.push(15)

# Popping an element from the stack
stack.pop

# Peeking at the top element of the stack
top_element = stack.peek
puts "Top element: #{top_element.data}"

# Getting the size of the stack
stack_size = stack.size
puts "Stack size: #{stack_size}"

# Clearing the stack
stack.clear

# Printing the stack elements
puts 'Stack elements:'
stack.print
