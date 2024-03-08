require_relative './1_singly_linked_list'

# A set is an unordered sequence of unique elements called members,
# grouped because they related to each other in some way.
class MySet
  # Initializes a new set with an empty singly linked list.
  def initialize
    @list = SinglyLinkedList.new
  end

  # Inserts a new member into the set if it does not already exist.
  #
  # @param member [Object] The member to insert into the set.
  def insert(member)
    return if contains?(member)

    @list.insert(member)
  end

  # Removes a member from the set if it exists.
  #
  # @param member [Object] The member to remove from the set.
  def remove(member)
    node = @list.find_first do |nd|
      nd.data == member
    end

    @list.remove(node) if node
  end

  # Computes the union of the current set with another set.
  #
  # @param other [MySet] The other set to perform the union with.
  # @return [MySet] A new set containing the union of the two sets.
  def union(other)
    res = MySet.new
    @list.each do |nd|
      res.insert(nd.data)
    end
    other.each do |data|
      res.insert(data)
    end
    res
  end

  # Computes the intersection of the current set with another set.
  #
  # @param other [MySet] The other set to perform the intersection with.
  # @return [MySet] A new set containing the intersection of the two sets.
  def intersect(other)
    res = MySet.new
    @list.each do |nd|
      res.insert(nd.data) if other.contains?(nd.data)
    end
    res
  end

  # Computes the difference of the current set with another set.
  #
  # @param other [MySet] The other set to perform the difference with.
  # @return [MySet] A new set containing the difference of the two sets.
  def diff(other)
    res = MySet.new
    @list.each do |nd|
      res.insert(nd.data) unless other.contains?(nd.data)
    end
    res
  end

  # Checks if the set contains a specific member.
  #
  # @param member [Object] The member to check for in the set.
  # @return [Boolean] True if the member is present, otherwise false.
  def contains?(member)
    @list.includes?(member)
  end

  # Checks if the current set is a subset of another set.
  #
  # @param other [MySet] The other set to compare against.
  # @return [Boolean] True if the current set is a subset of the other set, otherwise false.
  def subset?(other)
    return false if count > other.count

    @list.each do |nd|
      return false unless other.contains?(nd.data)
    end
    true
  end

  # Checks if the current set is equal to another set.
  #
  # @param other [MySet] The other set to compare against.
  # @return [Boolean] True if the current set is equal to the other set, otherwise false.
  def equal?(other)
    return false unless count == other.count

    subset?(other)
  end

  # Gets the count of members in the set.
  #
  # @return [Integer] The number of members in the set.
  def count
    @list.length
  end

  # Iterates over each member in the set.
  #
  # @yield [Object] The block to be executed for each member.
  def each
    return unless block_given?

    current = @list.head
    while current
      yield current&.data
      current = current.next
    end
  end

  # Prints the members of the set.
  def print
    @list.print
  end
end

# USAGE EXAMPLES

# Create a new set
my_set = MySet.new

# Insert members into the set
my_set.insert(5)
my_set.insert(10)
my_set.insert(15)

# Print the set
my_set.print
# Output:
# 5
# 10
# 15

# Remove a member from the set
my_set.remove(5)

# Print the set after removal
my_set.print
# Output:
# 10
# 15

# Create another set
other_set = MySet.new
other_set.insert(10)
other_set.insert(20)
other_set.insert(25)

# Perform union operation between sets
union_set = my_set.union(other_set)
union_set.print
# Output:
# 10
# 15
# 20
# 25

# Perform intersection operation between sets
intersect_set = my_set.intersect(other_set)
intersect_set.print
# Output:
# 10

# Perform difference operation between sets
diff_set = my_set.diff(other_set)
diff_set.print
# Output:
# 15

# Check if a member is present in the set
puts my_set.contains?(10) # true
puts my_set.contains?(20) # false

# Check if a set is a subset of another set
puts my_set.subset?(other_set) # false

# Check if two sets are equal
puts my_set.equal?(other_set) # false

# Get the count of members in the set
puts my_set.count # 2

# Iterate over the set
my_set.each { |member| puts member }
# Output:
# 15
# 5
