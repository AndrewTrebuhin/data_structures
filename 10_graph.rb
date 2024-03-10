require_relative './1_singly_linked_list'
require_relative './7_set'

# This patched version of SinglyLinkedList
# allows us to remove vertices in
# constant time.
class SinglyLinkedList
  def remove_next(prev_node)
    return nil unless @length > 0

    if prev_node
      if prev_node.next == prev_node
        @head = nil
      else
        old = prev_node.next
        prev_node.next = prev_node.next&.next
        @head = old.next if old == @head
      end
    else
      @head = @head.next
    end

    @length -= 1
  end
end

# A graph is a data structure that allows us to represent
# data in terms of objects and relationships.
# Objects on a graph are called vertices (or nodes),
# and their connections to other vertices are called edges.
class Graph
  class Vertex
    # Initializes a new vertex with the given key.
    #
    # @param key [Object] The key of the vertex.
    def initialize(key)
      @key = key
      @edges = MySet.new
    end

    # Returns the string representation of the vertex.
    #
    # @return [String] The string representation of the vertex.
    def to_s
      @key.to_s
    end

    # The key of the vertex.
    attr_accessor :key

    # The edges connected to the vertex.
    attr_accessor :edges
  end

  # Initializes a new graph.
  def initialize
    @vertices = SinglyLinkedList.new
  end

  # Finds a vertex in the graph by its key.
  #
  # @param key [Object] The key of the vertex to find.
  # @return [Vertex, nil] The found vertex, or nil if not found.
  def find_vertex(key)
    @vertices.find_first do |v|
      v.data.key == key
    end
  end

  # Inserts a new vertex into the graph with the given key.
  #
  # @param key [Object] The key of the vertex to insert.
  def insert_vertex(key)
    return if find_vertex(key)

    vertex = Vertex.new(key)
    @vertices.insert(vertex)
  end

  # Inserts an edge between two vertices in the graph.
  #
  # @param key1 [Object] The key of the first vertex.
  # @param key2 [Object] The key of the second vertex.
  def insert_edge(key1, key2)
    v1 = find_vertex(key1)
    return unless v1

    v2 = find_vertex(key2)
    return unless v2

    v1.data.edges.insert(v2.data.key)
  end

  # Removes a vertex from the graph by its key.
  #
  # @param key [Object] The key of the vertex to remove.
  def remove_vertex(key)
    found = false
    target = nil
    prev = nil

    @vertices.each do |v|
      return if v.data.edges.contains?(key)

      if v.data.key == key
        found = true
        target = v.data
      end
      prev = v unless found
    end

    return unless found
    return unless target.edges.count == 0

    @vertices.remove_next(prev)
  end

  # Removes an edge between two vertices in the graph.
  #
  # @param key1 [Object] The key of the first vertex.
  # @param key2 [Object] The key of the second vertex.
  def remove_edge(key1, key2)
    vertex = find_vertex(key1)&.data
    return unless vertex

    vertex.edges.remove(key2)
  end

  # Checks if two vertices in the graph are adjacent.
  #
  # @param key1 [Object] The key of the first vertex.
  # @param key2 [Object] The key of the second vertex.
  # @return [Boolean] True if the vertices are adjacent, false otherwise.
  def adjacent?(key1, key2)
    vertex = find_vertex(key1)&.data

    vertex&.edges&.contains?(key2) ? true : false
  end

  # Prints the graph, including vertices and their edges.
  def print
    @vertices.each do |v|
      puts "#{v.data} (vertex)"
      v.data.edges.each do |e|
        puts "    #{e} (edge)"
      end
    end
  end
end

# USAGE EXAMPLES

# Create a new graph
graph = Graph.new

# Insert vertices into the graph
graph.insert_vertex('A')
graph.insert_vertex('B')
graph.insert_vertex('C')

# Insert edges between vertices
graph.insert_edge('A', 'B')
graph.insert_edge('A', 'C')
graph.insert_edge('B', 'C')

# Check if vertices are adjacent
puts graph.adjacent?('A', 'B')  # Output: true
puts graph.adjacent?('B', 'C')  # Output: true
puts graph.adjacent?('A', 'C')  # Output: true

# Remove edges between vertices
graph.remove_edge('A', 'C')

# Check adjacency after edge removal
puts graph.adjacent?('A', 'C') # Output: false

# Remove edges between vertices
graph.remove_edge('B', 'C')

# Remove a vertex from the graph
graph.remove_vertex('C')

# Print the graph
graph.print
