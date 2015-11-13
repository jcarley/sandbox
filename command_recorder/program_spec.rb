require_relative "program"

RSpec.describe Recorder do

  it "sends the append message" do
    receiver = double("receiver", :append => nil)
    recorder = Recorder.new
    recorder.append("foo")
    recorder.merge_into(receiver)
    expect(receiver).to have_received(:append)
  end

  it "sends the insert message" do
    receiver = double("receiver", :insert => nil)
    recorder = Recorder.new
    recorder.insert("foo")
    recorder.merge_into(receiver)
    expect(receiver).to have_received(:insert)
  end

  it "sends the insert_before message" do
    receiver = double("receiver", :insert_before => nil)
    recorder = Recorder.new
    recorder.insert_before("foo")
    recorder.merge_into(receiver)
    expect(receiver).to have_received(:insert_before)
  end

  it "sends the delete message" do
    receiver = double("receiver", :delete => nil)
    recorder = Recorder.new
    recorder.delete("foo")
    recorder.merge_into(receiver)
    expect(receiver).to have_received(:delete)
  end

end

RSpec.describe RuntimeStack do

  it "appends a new item" do
    runtime_stack = RuntimeStack.new
    runtime_stack.append("foo")
    expect(runtime_stack.stack).to include("foo")
  end

  it "inserts a new item at an index" do
    runtime_stack = RuntimeStack.new
    runtime_stack.append("foo")
    runtime_stack.append("bar")
    runtime_stack.insert(1, "quax")
    expect(runtime_stack.stack[1]).to eql("quax")
  end

  it "inserts a new item before another item" do
    runtime_stack = RuntimeStack.new
    runtime_stack.append("foo")
    runtime_stack.append("bar")
    runtime_stack.insert_before("quax", "bar")
    expect(runtime_stack.stack[1]).to eql("quax")
  end

  it "deletes an item" do
    runtime_stack = RuntimeStack.new
    runtime_stack.append("foo")
    runtime_stack.append("bar")
    runtime_stack.delete("bar")
    expect(runtime_stack.stack).to_not include("bar")
  end

  # fubu bar baz quax
  it "gets items merged into it without error" do
    runtime_stack = RuntimeStack.new
    runtime_stack.append("foo")
    runtime_stack.append("bar")
    runtime_stack.append("baz")

    recorder = Recorder.new
    recorder.delete("foo")
    recorder.append("quax")
    recorder.insert_before("fubu", "foo")

    recorder.merge_into(runtime_stack)
    expect(runtime_stack.stack).to eql(%w(fubu bar baz quax))
  end

end

