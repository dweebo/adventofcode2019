require "Day4"

RSpec.describe Day4 do

  let(:start_range) { 367479 }
  let(:end_range) { 893698 }

  subject { described_class.new(start_range, end_range) }

  describe "#check_increasing" do
    it "passes" do
      expect(subject.check_increasing(12345)).to be_truthy
    end

    it "passes on same" do
      expect(subject.check_increasing(1223455)).to be_truthy
    end

    it "fails on decreasing" do
      expect(subject.check_increasing(123454)).to be_falsey
    end

  end

  describe "#check_double" do
    it "passes" do
      expect(subject.check_double(22)).to be_truthy
    end

    it "passes 2" do
      expect(subject.check_double(123455)).to be_truthy
    end

    it "fails" do
      expect(subject.check_double(123456)).to be_falsey
    end
  end

  describe "find password counts" do
    context "range1" do
      let(:start_range) { 10 }
      let(:end_range) { 20 }

      it "counts correctly" do
        expect(subject.part1).to eq(1)
      end
    end

    context "range2" do
      let(:start_range) { 1 }
      let(:end_range) { 100 }

      it "counts correctly" do
        expect(subject.part1).to eq(9)
      end
    end

    context "range3" do
      let(:start_range) { 111 }
      let(:end_range) { 120 }

      it "counts correctly" do
        expect(subject.part1).to eq(9)
      end
    end

    context "real input part1" do
      it "counts correctly" do
        expect(subject.part1).to eq(495)
      end
    end

    context "part2 diff" do
      let(:start_range) { 1111 }
      let(:end_range) { 1120 }

      it "counts correctly" do
        expect(subject.part2).to eq(0)
      end
    end

    context "part2 diff" do
      let(:start_range) { 1123 }
      let(:end_range) { 1130 }

      it "counts correctly" do
        expect(subject.part2).to eq(7)
      end
    end

    context "part2 diff2" do
      let(:start_range) { 1244 }
      let(:end_range) { 1250 }

      it "counts correctly" do
        expect(subject.part2).to eq(1)
      end

    context "real input part2" do
      it "counts correctly" do
        expect(subject.part2).to eq(305)
      end
    end
  end
end
