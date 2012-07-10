require 'spec_helper'
require 'support/example_prescription_fulfillment'
require 'support/making_hash_like_objects'
require 'support/perturbing_hash_like_objects'

require 'object_diff/hash_diff'

describe ObjectDiff::HashDiff do

  include MakingHashLikeObjects
  include PerturbingHashLikeObjects

  describe "#different?" do

    it "is false for identical hash-like objects" do
      diff = ObjectDiff::HashDiff.new( hash_like(no: :change), hash_like(no: :change) )
      diff.different?.should eq( false )
    end

    it "is true for different hash-like objects" do
      diff = ObjectDiff::HashDiff.new( hash_like(change: :from), hash_like(change: :to) )
      diff.different?.should eq( true )
    end

  end

  describe "#unified_diff" do

    it "produces an empty string for identical hash-like objects" do
      diff = ObjectDiff::HashDiff.new( hash_like(no: :change), hash_like(no: :change) )
      diff.unified_diff.should eq( '' )
    end

    it "produces unified diff output for different hash-like objects" do
      diff = ObjectDiff::HashDiff.new( hash_like(change: :from), hash_like(change: :to) )
      diff.unified_diff.should eq( "- :change: :from\n+ :change: :to\n" )
    end

    for_each_example_prescribed_by('hash_diff/*.txt') do |prescription|
      it "produces the expected output" do
        hash_diff = ObjectDiff::HashDiff.new( prescription.input(:old), prescription.input(:new) )
        hash_diff.unified_diff.should eq( prescription.expected_output )
      end
    end

    it "caches the first comparison to avoid recomparison on subsequent access" do
      diff = ObjectDiff::HashDiff.new( hash_like(no: :change), one_of_them = hash_like(no: :change) )
      expect { perturbing(one_of_them) }.to_not change { diff.unified_diff }
    end

  end

end 
