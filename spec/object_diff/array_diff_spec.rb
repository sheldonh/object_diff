require 'spec_helper'
require 'support/example_prescription_fulfillment'

require 'object_diff/array_diff'

def perturbing(array)
  array << :perturbed
end

describe ObjectDiff::ArrayDiff do

  describe "#different?" do

    it "is false for identical arrays" do
      diff = ObjectDiff::ArrayDiff.new([:both, :identical], [:both, :identical])
      diff.different?.should eq(false)
    end

    it "is true for different arrays" do
      diff = ObjectDiff::ArrayDiff.new([:different, :from], [:each, :other])
      diff.different?.should eq(true)
    end

  end

  describe "#unified_diff" do

    it "produces an empty string for identical arrays" do
      diff = ObjectDiff::ArrayDiff.new([:both, :identical], [:both, :identical])
      diff.unified_diff.should eq('')
    end

    it "produces unified diff output for different arrays" do
      diff = ObjectDiff::ArrayDiff.new([:same, :changed_from], [:same, :changed_to])
      diff.unified_diff.should eq("- 1: :changed_from\n+ 1: :changed_to\n")
    end

    for_each_example_prescribed_by('array_diff/*.txt') do |prescription|
      it "produces the expected output" do
        diff = ObjectDiff::ArrayDiff.new( prescription.input(:old), prescription.input(:new) )
        diff.unified_diff.should eq( prescription.expected_output )
      end
    end

    it "caches the first comparison to avoid recomparison on subsequent access" do
      diff = ObjectDiff::ArrayDiff.new( [:no, :change], one_of_them = [:no, :change] )
      expect { perturbing(one_of_them) }.to_not change { diff.unified_diff }
    end

  end

end
