require "Day2"
RSpec.describe Day2 do
  describe "#execute" do

    subject { described_class.new(file, noun, verb) }
    let(:noun) { nil }
    let(:verb) { nil }

    context "sample one" do
      let(:file) { "lib/day2-test1.txt" }

      it "executes add" do
        subject.execute
        expect(subject.instructions[0]).to eq(2)
      end
    end

    context "sample two" do
      let(:file) { "lib/day2-test2.txt" }

      it "executes mult" do
        subject.execute
        expect(subject.instructions[3]).to eq(6)
      end
    end

    context "sample three" do
      let(:file) { "lib/day2-test3.txt" }

      it "executes both" do
        subject.execute
        expect(subject.instructions).to eq([
          30,1,1,4,2,5,6,0,99
        ])
      end
    end

    context "part1" do
      let(:file) { "lib/day2.txt" }
      let(:noun) { 12 }
      let(:verb) { 2 }

      it "completes part 1" do
        subject.execute
        expect(subject.instructions[0]).to eq(3765464)
      end
    end

    context "part2-brute" do
      let(:file) { "lib/day2.txt" }
      let(:expected_answer) { 19690720 }
      it "brute forces the answer" do

        for noun in (0..99) do
          for verb in (0..99) do
            day2 = Day2.new(file, noun, verb)
            day2.execute
            if day2.instructions[0] == expected_answer
              puts "noun=#{noun} verb=#{verb}"
            end
          end
        end
      end
    end

    context "part2-verify" do
      let(:file) { "lib/day2.txt" }
      let(:noun) { 76 }
      let(:verb) { 10 }
      let(:expected_answer) { 19690720 }
      let(:solution) { 7610 }

      it "completes part 2" do
        subject.execute
        expect(subject.instructions[0]).to eq(expected_answer)
        expect(solution).to eq(100 * noun + verb)
      end
    end
  end
end
