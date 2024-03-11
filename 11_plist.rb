require_relative '1_singly_linked_list'

# This patched version of SinglyLinkedList
# allows us to reuse some nodes while 
# working with immutable lists.
class SinglyLinkedList
  # Reuses nodes from the target node
  # to the end of the list.
  def reuse_from_node(node)
    @tail.next = node
    len = 1
    tmp = node
    while tmp = tmp.next
      len += 1
    end
    # *len* is the distance from the
    # target node to EOL.
    @length += len
  end

  def insert(data)
    node = PList::Node.new(data)
    if head
      @tail.next = node
    else
      @head = node
    end
    @tail = node
    @length += 1
  end
end

# Persistently Linked List is a data structure that behaves almost the same as
# a regular linked list but is immutable and has a copy on write semantics.
class PList
  class Node
    attr_accessor :data, :next

    # Initializes a new Node with the given data.
    #
    # @param data [Object] The data to store in the node.
    def initialize(data)
      @data = data
      @data.freeze
    end

    # Returns the string representation of the node's data.
    #
    # @return [String] The string representation of the data.
    def to_s
      @data&.to_s || 'nil'
    end
  end

  class << self
    # Creates an empty persistent list.
    #
    # @return [SinglyLinkedList] An empty persistent list.
    def empty
      list = SinglyLinkedList.new
      list.freeze
    end

    # Inserts an element into the persistent list.
    #
    # @param list [SinglyLinkedList] The original list.
    # @param data [Object] The data to insert into the list.
    # @return [SinglyLinkedList] A new persistent list with the data inserted.
    def insert(list, data)
      ret = copy(list)
      ret.insert(data)
      ret.freeze
    end

    # Updates an element in the persistent list.
    #
    # @param list [SinglyLinkedList] The original list.
    # @param node [PList::Node] The node to update.
    # @param data [Object] The new data to replace the existing data in the node.
    # @return [SinglyLinkedList] A new persistent list with the specified node updated with the new data.
    def update(list, node, data)
      ret = SinglyLinkedList.new
      reuse = false
      found = false

      list.each do |nd|
        unless found
          found = (nd.data == node.data)
          if found
            ret.insert(data)
            reuse = true
            next
          end
        end
        if reuse
          ret.reuse_from_node(nd)
          break
        else
          ret.insert(data)
        end
      end
      ret.freeze
    end

    # Removes an element from the persistent list.
    #
    # @param list [SinglyLinkedList] The original list.
    # @param node [PList::Node] The node to remove from the list.
    # @return [SinglyLinkedList] A new persistent list with the specified node removed.
    def remove(list, node)
      ret = SinglyLinkedList.new
      reuse = false
      found = false

      list.each do |nd|
        unless found
          found = (nd.data == node.data)
          if found
            reuse = true
            next
          end
        end
        if reuse
          ret.reuse_from_node(nd)
          break
        else
          ret.insert(nd.data)
        end
      end
      ret.freeze
    end

    # Concatenates two persistent lists.
    #
    # @param lhs [SinglyLinkedList] The first list.
    # @param rhs [SinglyLinkedList] The second list.
    # @return [SinglyLinkedList] A new persistent list containing elements from both input lists.
    def cat(lhs, rhs)
      ret = copy(lhs)
      ret.cat(rhs)
      ret.freeze
    end

    # Calculates the length of the persistent list.
    #
    # @param list [SinglyLinkedList] The list to calculate the length of.
    # @return [Integer] The length of the list.
    def len(list)
      list&.length || 0
    end

    # Finds the first element in the persistent list satisfying the given predicate.
    #
    # @param list [SinglyLinkedList] The list to search.
    # @param &predicate [Proc] A block specifying the condition for the element.
    # @return [PList::Node, nil] The first element satisfying the predicate, or `nil` if none is found.
    def find_first(list, &predicate)
      return nil unless list

      list.find_first(&predicate)
    end

    # Iterates over each element in the persistent list.
    #
    # @param list [SinglyLinkedList] The list to iterate over.
    # @param &block [Proc] A block to execute for each element.
    # @return [nil]
    def each(list, &block)
      return nil unless list

      list.each(&block)
    end

    # Prints the contents of the persistent list.
    #
    # @param list [SinglyLinkedList] The list to print.
    # @return [nil]
    def print(list)
      return unless list

      list.print
    end

    private

    # Copies the contents of the source list into a new list.
    #
    # @param src [SinglyLinkedList] The source list.
    # @return [SinglyLinkedList] A copy of the source list.
    def copy(src)
      dst = SinglyLinkedList.new
      src.each do |node|
        dst.insert(node.data)
      end
      dst
    end
  end
end

# USAGE EXAMPLES

# Create an empty list
list = PList.empty

# Insert elements into the list
list = PList.insert(list, 10)
list = PList.insert(list, 20)
list = PList.insert(list, 30)

# Update an element in the list
node = PList.find_first(list) { |nd| nd.data == 20 }
list = PList.update(list, node, 25)

# Remove an element from the list
node = PList.find_first(list) { |nd| nd.data == 30 }
list = PList.remove(list, node)

# Concatenate two lists
list1 = PList.insert(list, 40)
list2 = PList.insert(list, 50)
list = PList.cat(list1, list2)

# Get the length of the list
PList.len(list)

# Find the first element satisfying a condition
PList.find_first(list) { |nd| nd.data > 20 }

# Iterate over each element in the list
PList.each(list) { |nd| puts nd }

# Print the contents of the list
PList.print(list)
