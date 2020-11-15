require_relative '../function_evaluator'

RSpec.describe FunctionEvaluator do
  let(:subject) { described_class.new(@expression) }
  context "finding parameters" do
    context "with no params" do
      it "works with no params" do
        @expression = "1 + 2"
        expect(subject.find_params).to match_array([])
      end

      it "works with a divided-by-zero expression" do
        @expression = "0 / 0"
        expect(subject.find_params).to match_array([])
      end

      it "works with a out-of-domain expression" do
        @expression = "Math.sqrt(-1)"
        expect(subject.find_params).to match_array([])
      end
    end

    context "with one param" do
      it "works with just 'x'" do
        @expression = "x + 1"
        expect(subject.find_params).to match_array([:x])
      end

      it "works with several appearances of 'x'" do
        @expression = "x + 1 * x / 2"
        expect(subject.find_params).to match_array([:x])
      end

      it "Finds 'x' even with a divided-by-zero expression" do
        @expression = "x + 0 / 0"
        expect(subject.find_params).to match_array([:x])
      end

      it "Finds 'x' even when its default value will generate a divided-by-zero" do
        @expression = "x + 1 / (x - 1)"
        expect(subject.find_params).to match_array([:x])
      end

      it "Finds 'x' even with a out-of-domain expression" do
        @expression = "x + Math.sqrt(-1)"
        expect(subject.find_params).to match_array([:x])
      end

      it "Finds 'x' even when its default value will generate a out-of-domain" do
        @expression = "x + Math.sqrt(x - 100)"
        expect(subject.find_params).to match_array([:x])
      end
    end

    context "with 2 params" do
      it "works with 2 params" do
        @expression = "a * x + 1"
        expect(subject.find_params).to match_array([:x, :a])
      end

      it "works with 2 params when repeated" do
        @expression = "a * x * x + 1 + a ** 3"
        expect(subject.find_params).to match_array([:x, :a])
      end

      it "works with 2 params even with a divided-by-zero expression" do
        @expression = "a * x * x + 1 + a ** 3 + 0 / 0"
        expect(subject.find_params).to match_array([:x, :a])
      end

      it "works with 2 params even with a divided-by-zero expression induced by param default values" do
        @expression = "x + 1 / (x - 1) + a"
        expect(subject.find_params).to match_array([:x, :a])
      end

      it "works with 2 params even with a divided-by-zero expression induced by param default values and cascading" do
        @expression = "x + 1 / (x - a) + a / (a - 1) + a / (a - 2)"
        expect(subject.find_params).to match_array([:x, :a])
      end
    end
  end
end
