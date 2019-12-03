require "Day3"
RSpec.describe Day3 do
  describe "#part1" do

    subject { described_class.new(file) }

    context "move" do
      let(:file) { "lib/day3-test1.txt" }
      let(:current_point) { Day3::WirePoint.new(1, 2) }
      context "right" do
        let(:instruction) { "R5" }

        it "moves right" do
          expect(subject.move(current_point, instruction).to_set).to eq(Set[
            Day3::WirePoint.new(2, 2),
            Day3::WirePoint.new(3, 2),
            Day3::WirePoint.new(4, 2),
            Day3::WirePoint.new(5, 2),
            Day3::WirePoint.new(6, 2)
          ])
        end
      end
      context "left" do
        let(:instruction) { "L3" }

        it "moves right" do
          expect(subject.move(current_point, instruction).to_set).to eq(Set[
            Day3::WirePoint.new(0, 2),
            Day3::WirePoint.new(-1, 2),
            Day3::WirePoint.new(-2, 2)
          ])
        end
      end
    end

    context "lay_wire" do
      let(:file) { "lib/day3-test1.txt" }
      let(:wire) { [ "R2", "U3", "L1", "D4" ] }

      it "lays wire" do
        coords = subject.lay_wire(wire)
        expect(coords).to eq(Set[
          Day3::WirePoint.new(1, 0), Day3::WirePoint.new(2, 0),
          Day3::WirePoint.new(2, -1), Day3::WirePoint.new(2, -2), Day3::WirePoint.new(2, -3),
          Day3::WirePoint.new(1, -3),
          Day3::WirePoint.new(1, -2), Day3::WirePoint.new(1, -1), Day3::WirePoint.new(1, 1)
        ])
      end
    end

    context "sample zero" do
      let(:file) { "lib/day3-test0.txt" }

      it "finds point" do
        expect(subject.part1).to eq(6)
      end
    end

    context "sample one" do
      let(:file) { "lib/day3-test1.txt" }

      it "part1" do
        expect(subject.part1).to eq(159)
      end

      it "part2" do
        expect(subject.part2).to eq(610)
      end
    end

    context "sample two" do
      let(:file) { "lib/day3-test2.txt" }

      it "part1" do
        expect(subject.part1).to eq(135)
      end

      it "part2" do
        expect(subject.part2).to eq(410)
      end
    end

    context "part1" do
      let(:file) { "lib/day3.txt" }

      it "finds point" do
        expect(subject.part1).to eq(227)
      end
    end

    context "part2" do
      let(:file) { "lib/day3.txt" }

      it "finds point" do
        expect(subject.part2).to eq(20286)
      end
    end
  end
end
