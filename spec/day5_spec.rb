require "Day5"
RSpec.describe Day5 do
  describe "#execute" do

    subject { described_class.new(file) }
    let(:file) { "lib/day5.txt" }

    context "#parse_opcode" do
       it "parses when just the code" do
         expect(subject.parse_opcode(Day5::OPCODE_END)).to eq(Day5::OPCODE_END)
       end

       it "parses when just a single-digit code" do
         expect(subject.parse_opcode(Day5::OPCODE_ADD)).to eq(Day5::OPCODE_ADD)
       end

       it "parses when the code and one mode digit" do
         expect(subject.parse_opcode(101)).to eq(Day5::OPCODE_ADD)
       end

       it "parses when the code and three mode digits" do
         expect(subject.parse_opcode(10101)).to eq(Day5::OPCODE_ADD)
       end
    end

    context "#parse_modes" do
       it "parses when just the code" do
         expect(subject.parse_modes(1)).to eq([
           Day5::PARAM_MODE_POSITION,
           Day5::PARAM_MODE_POSITION,
           Day5::PARAM_MODE_POSITION
         ])
       end

       it "parses when the code and one mode digit" do
         expect(subject.parse_modes(101)).to eq([
           Day5::PARAM_MODE_IMMEDIATE,
           Day5::PARAM_MODE_POSITION,
           Day5::PARAM_MODE_POSITION,
         ])
       end

       it "parses when the code and two mode digit" do
         expect(subject.parse_modes(1101)).to eq([
           Day5::PARAM_MODE_IMMEDIATE,
           Day5::PARAM_MODE_IMMEDIATE,
           Day5::PARAM_MODE_POSITION
         ])
       end

       it "parses when the code and three mode digit" do
         expect(subject.parse_modes(10101)).to eq([
           Day5::PARAM_MODE_IMMEDIATE,
           Day5::PARAM_MODE_POSITION,
           Day5::PARAM_MODE_IMMEDIATE
         ])
       end
    end

    context "sample one" do
      let(:file) { "lib/day5-test1.txt" }

      it "executes add by position and value" do
        subject.execute
        expect(subject.instructions[0]).to eq(2)
        expect(subject.instructions[1]).to eq(11)
        expect(subject.instructions[2]).to eq(20)
      end
    end

    context "part1" do

      it "executes part 1" do
        allow($stdin).to receive(:gets).and_return("1\n")
        subject.execute
      end
    end

    context "part2 test 1" do
      let(:file) { "lib/day5-part2-test1.txt" }

      it "executes part 2" do
        allow($stdin).to receive(:gets).and_return("8\n")
        subject.execute
      end
    end

    context "part2" do

      it "executes part 2" do
        allow($stdin).to receive(:gets).and_return("5\n")
        subject.execute
      end
    end
  end
end
