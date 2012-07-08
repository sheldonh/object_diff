require 'spec_helper'
require 'support/example_factory'
require 'support/perturbations'
require 'object_diff'

include Perturbations

describe ObjectDiff::HashDiff do

  describe "#different?" do

    it "is false for identical hashes" do
      hash_diff = ObjectDiff::HashDiff.new( { no: :change }, { no: :change } )
      hash_diff.different?.should eq( false )
    end

    it "is true for different hashes" do
      hash_diff = ObjectDiff::HashDiff.new( { change: :from }, { change: :to } )
      hash_diff.different?.should eq( true )
    end

  end

  describe "#unified_diff" do

    it "produces an empty string for identical hashes" do
      hash_diff = ObjectDiff::HashDiff.new( { no: :change }, { no: :change } )
      hash_diff.unified_diff.should eq( '' )
    end

    it "produces unified diff output for different hashes" do
      hash_diff = ObjectDiff::HashDiff.new( { change: :from }, { change: :to } )
      hash_diff.unified_diff.should eq( "- :change: :from\n+ :change: :to\n" )
    end

    extend ExampleFactory

    # TODO I would prefer more explicit it_fulfills_examples('spec/examples/*-test.txt')
    it_fulfills_examples('*-test.txt')

    it "caches the first comparison to avoid recomparison on subsequent access" do
      old, new = { no: :change }, { no: :change }
      hash_diff = ObjectDiff::HashDiff.new( old, new )
      expect { making_a_change_to_hash(new) }.to_not change { hash_diff.unified_diff }
    end

  end

end 
