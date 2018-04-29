require 'pry'

RSpec.describe 'User reading a book' do
  context 'reading first time' do
    after do
      File.unlink('testing_this.yaml') if File.exist?('testing_this.yaml')
    end

    it 'starts tracking immediately' do
      input = StringIO.new
      output = StringIO.new
      input.puts "\n"
      input.puts "q\n"
      input.rewind
      Readspeed::Tracker.new('testing this', input: input, output: output).start
      output.rewind
      lines = output.readlines.last(2)
      expect(lines[0]).to match /0> Finished page 1. Last: 0.0 Average: 0.0 Total: 0.0/
      expect(lines[1]).to match /1> Writing summary to testing_this.yaml/
    end
  end
end
