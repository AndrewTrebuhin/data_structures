# A hash table is a data structure optimized for random reads where
# entries are stored as key-value pairs into an internal array.
# Since we access elements by hashing their key to a particular position
# within the internal array, (assuming approximation to uniform hashing)
# searches run in constant time.
class HashTable
  # Represents a slot in the hash table.
  class Slot
    # Initializes a new slot with the given key and value.
    #
    # @param key [Object] The key of the slot.
    # @param value [Object] The value of the slot.
    def initialize(key, value)
      @key = key
      @value = value
      @vacated = false
    end

    attr_accessor :key, :value, :vacated

    # Marks the slot as vacated, making it available for reuse.
    def free
      @value = nil
      @vacated = true
    end
  end

  # Initializes a new hash table with default settings.
  def initialize
    @slots = 5
    fill_table(@slots)
    @size = 0
    @rebuilds = 0
    @h1 = ->(k) { k % @slots }
    @h2 = ->(k) { 1 + (k % (@slots - 1)) }
  end

  # Returns the number of key-value pairs in the hash table.
  attr_reader :size

  # Inserts or updates a key-value pair in the hash table.
  #
  # @param key [Object] The key of the pair.
  # @param value [Object] The value of the pair.
  def upsert(key, value)
    if slot = find_slot(key)
      return slot.value = value
    end

    rebuild if @size > (@slots / 2)

    0.upto(@slots - 1) do |i|
      index = double_hash(key.hash, i)
      slot = @table[index]
      if slot.nil? || slot.vacated
        @table[index] = Slot.new(key, value)
        @size += 1
        return
      end
    end

    raise 'Weak hash function.'
  end

  # Retrieves the value associated with the given key from the hash table.
  #
  # @param key [Object] The key to search for.
  # @return [Object, nil] The value associated with the key, or nil if not found.
  def get(key)
    0.upto(@slots - 1) do |i|
      index = double_hash(key.hash, i)
      slot = @table[index]
      return nil if slot.nil? || slot.vacated

      return slot.value if slot.key == key
    end
    nil
  end

  # Removes the key-value pair with the given key from the hash table.
  #
  # @param key [Object] The key to remove.
  def delete(key)
    find_slot(key)&.free
  end

  # Finds the slot associated with the given key in the hash table.
  #
  # @param key [Object] The key to search for.
  # @return [Slot, nil] The slot associated with the key, or nil if not found.
  def find_slot(key)
    0.upto(@slots - 1) do |i|
      index = double_hash(key.hash, i)
      slot = @table[index]

      return nil if slot.nil?
      return slot if slot.key == key
    end
    nil
  end

  # Prints the key-value pairs stored in the hash table.
  def print
    @table.each do |e|
      puts "#{e.key}: #{e.value}" if e
    end
    nil
  end

  private

  PRIMES = [13, 31, 61, 127, 251, 509].freeze
  MAX_REBUILDS = 6

  # Rebuilds the hash table with an increased size.
  def rebuild
    raise 'Too many entries.' if @rebuilds >= MAX_REBUILDS

    old = @table
    @slots = PRIMES[@rebuilds]
    @size = 0
    fill_table(@slots)
    old.each do |e|
      upsert(e.key, e.value) if e
    end
    @rebuilds += 1
  end

  # Fills the hash table with nil slots.
  #
  # @param slots [Integer] The number of slots to fill.
  def fill_table(slots)
    @table = []
    0.upto(slots - 1) { @table << nil }
  end

  # Performs double hashing to calculate the index for a given key.
  #
  # @param hashcode [Integer] The hash code of the key.
  # @param idx [Integer] The current iteration index.
  # @return [Integer] The calculated index for the key.
  def double_hash(hashcode, idx)
    h1 = @h1.call(hashcode)
    h2 = @h2.call(hashcode)
    ((h1 + (idx * h2)) % @slots).abs
  end
end

# USAGE EXAMPLES

# Creating a new instance of HashTable
hash_table = HashTable.new

# Upserting key-value pairs
hash_table.upsert(:apple, 10)
hash_table.upsert(:banana, 20)
hash_table.upsert(:orange, 30)

# Getting values by keys
puts "Value for :banana: #{hash_table.get(:banana)}"

# Deleting a key-value pair
hash_table.delete(:banana)

# Printing the hash table
puts 'Hash table contents after deletion:'
hash_table.print
