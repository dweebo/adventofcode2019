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
  end
end
