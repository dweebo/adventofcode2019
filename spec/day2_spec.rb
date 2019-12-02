require "Day2"
RSpec.describe Day2 do
  describe "#execute" do

    subject {
      described_class.new(file)
    }

    context "sample one" do
      let(:file) {
        "lib/day2-test1.txt"
      }

      it "reads instructions" do
        subject.execute
        expect(subject.instructions[0]).to eq(2)
      end
    end

    context "sample two" do
      let(:file) {
        "lib/day2-test2.txt"
      }

      it "reads instructions" do
        subject.execute
        expect(subject.instructions[3]).to eq(6)
      end
    end

    context "sample three" do
      let(:file) {
        "lib/day2-test3.txt"
      }

      it "reads instructions" do
        subject.execute
        expect(subject.instructions).to eq([
          30,1,1,4,2,5,6,0,99
        ])
      end
    end

    context "part1" do
      let(:file) {
        "lib/day2.txt"
      }
      it "completes part 1" do
        subject.instructions[1] = 12
        subject.instructions[2] = 2
        subject.execute

        expect(subject.instructions[0]).to eq(0)
      end
    end
  end
end
