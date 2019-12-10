require "int_code"
RSpec.describe IntCode do
  describe "#execute" do

    subject {
      subj = described_class.new(file)
      subj.set_input_reader(input_reader)
      subj
    }
    let(:file) { "lib/day9-test3.txt" }
    let(:input_reader) {
      double
    }
    before(:each) do
      allow(input_reader).to receive(:read).and_return(5)
    end

    context "#input" do
       it "works with relative" do
         modes = subject.parse_modes(subject.instructions[0])
         subject.input(0, 80, modes)
         expect(subject.instructions[83]).to eq(5)
       end

       it "works with absolute" do
         subject.input(0, 80, [ 0, 0, 0 ])
         expect(subject.instructions[3]).to eq(5)
       end
    end
  end
end
