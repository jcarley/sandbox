
class Recorder

  def initialize
    @operations = []
    @delete_operations = []
  end

  def append(*args)
    operations << [__method__, args]
  end

  def insert(*args)
    operations << [__method__, args]
  end

  def insert_before(*args)
    operations << [__method__, args]
  end

  def delete(*args)
    delete_operations << [__method__, args]
  end

  def merge_into(other)
    (operations + delete_operations).each do |operation, args|
      other.send(operation, *args)
    end

    other
  end

  protected

  def operations
    @operations
  end

  def delete_operations
    @delete_operations
  end

end


class RuntimeStack

  attr_accessor :stack

  def initialize
    @stack = default_stack
  end

  def append(item)
    stack << item
  end

  def insert(index, item)
    stack.insert(index, item)
  end

  def insert_before(new_item, before_item)
    index = stack.find_index(before_item)
    stack.insert(index, new_item)
  end

  def delete(item)
    stack.delete(item)
  end

  private

  def default_stack
    %w(foo bar baz)
  end

end
