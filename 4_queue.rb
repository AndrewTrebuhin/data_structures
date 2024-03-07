# A queue is a special kind of singly linked list designed to
# efficiently store and retrieve elements in first in, first out basis (FIFO).
class MyQueue
  # Represents an element in the queue.
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

    # @return [Node, nil] The next node in the queue.
    attr_accessor :next
  end

  # Initializes a new empty queue.
  def initialize
    @head = nil
    @tail = nil
    @length = 0
  end

  # Adds an element to the end of the queue.
  #
  # @param data [Object] The data to be enqueued.
  def enqueue(data)
    node = Node.new(data)

    if @head
      @tail.next = node
    else
      @head = node
    end

    @tail = node
    @length += 1
  end

  # Removes and returns the front element of the queue.
  #
  # @return [Node, nil] The front element of the queue, or nil if the queue is empty.
  def dequeue
    return unless @length > 0

    @head = @head.next
    @tail = nil if @length == 1
    @length -= 1
  end

  # Returns the front element of the queue without removing it.
  #
  # @return [Node, nil] The front element of the queue, or nil if the queue is empty.
  def peek
    @head
  end

  # Returns the size of the queue.
  #
  # @return [Integer] The number of elements in the queue.
  def size
    @length
  end

  # Removes all elements from the queue.
  def clear
    dequeue while peek
  end

  # Iterates over each element in the queue.
  #
  # @yield [Node] The block to be executed for each element.
  def each
    return unless block_given?

    current = @head
    while current
      yield current

      current = current.next
    end
  end

  # Prints all elements in the queue.
  def print
    return unless @length > 0

    each do |node|
      puts node.data
    end
  end
end

# USAGE EXAMPLES

# Creating a new instance of MyQueue
queue = MyQueue.new

# Enqueueing elements
queue.enqueue(5)
queue.enqueue(10)
queue.enqueue(15)

# Dequeueing an element
queue.dequeue

# Peeking at the front element
front_element = queue.peek
puts "Front element: #{front_element.data}" if front_element

# Getting the size of the queue
queue_size = queue.size
puts "Queue size: #{queue_size}"

# Clearing the queue
queue.clear

# Printing the queue elements
puts 'Queue elements:'
queue.print
