require 'spec_helper'
require 'support/example_prescription_fulfillment'
require 'support/making_hash_like_objects'
require 'support/perturbing'
require 'object_diff'

describe ObjectDiff::HashDiff do

  describe "#different?" do

    it "is false for identical hashes" do
      diff = ObjectDiff::HashDiff.new( { no: :change }, { no: :change } )
      diff.different?.should eq( false )
    end

    it "is true for different hashes" do
      diff = ObjectDiff::HashDiff.new( { change: :from }, { change: :to } )
      diff.different?.should eq( true )
    end

  end

  describe "#unified_diff" do

    it "produces an empty string for identical hashes" do
      diff = ObjectDiff::HashDiff.new( { no: :change }, { no: :change } )
      diff.unified_diff.should eq( '' )
    end

    it "produces unified diff output for different hashes" do
      diff = ObjectDiff::HashDiff.new( { change: :from }, { change: :to } )
      diff.unified_diff.should eq( "- :change: :from\n+ :change: :to\n" )
    end

    extend ExamplePrescriptionFulfillment
    it_fulfills_the_examples_prescribed_by '*-test.txt'

    it "caches the first comparison to avoid recomparison on subsequent access" do
      old, new = { no: :change }, { no: :change }
      diff = ObjectDiff::HashDiff.new( old, new )
      expect { Perturbing.the_hash(new) }.to_not change { diff.unified_diff }
    end

  end

  describe "type support" do

    include MakingHashLikeObjects

    it "actually supports any hash-like objects that provide keys, include? and fetch methods" do
      diff = ObjectDiff::HashDiff.new( hash_like(:change => :from), { :change => :to } )
      diff.unified_diff.should eq( "- :change: :from\n+ :change: :to\n" )
    end

  end

end 
