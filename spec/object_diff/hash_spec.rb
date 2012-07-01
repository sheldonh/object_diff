require 'object_diff/hash'
require 'support/example_factory'
require 'support/perturbations'

include Perturbations

describe ObjectDiff::Hash do

  describe "#different?" do

    it "is false for identical hashes" do
      hash_diff = ObjectDiff::Hash.new( { no: :change }, { no: :change } )
      hash_diff.different?.should eq( false )
    end

    it "is true for different hashes" do
      hash_diff = ObjectDiff::Hash.new( { change: :from }, { change: :to } )
      hash_diff.different?.should eq( true )
    end

  end

  describe "#differences" do

    it "is empty for identical hashes" do
      hash_diff = ObjectDiff::Hash.new( { no: :change }, { no: :change } )
      hash_diff.differences.should be_empty
    end

    it "includes a removal when the old hash has a key missing from the new hash" do
      hash_diff = ObjectDiff::Hash.new( { removed: :value }, {} )
      hash_diff.differences.should include( ObjectDiff::Removal.new(:removed, :value) )
    end

    it "includes an addition when the new hash has a key missing from the old hash" do
      hash_diff = ObjectDiff::Hash.new( {}, { added: :value } )
      hash_diff.differences.should include( ObjectDiff::Addition.new(:added, :value) )
    end

    it "includes a removal and an addition when the value in the old hash is changed in the new hash" do
      hash_diff = ObjectDiff::Hash.new( { change: :from }, { change: :to } )
      hash_diff.differences.should include( ObjectDiff::Removal.new(:change, :from) )
      hash_diff.differences.should include( ObjectDiff::Addition.new(:change, :to) )
    end

    it "caches the first comparison to avoid recomparison on subsequent access" do
      old, new = { no: :change }, { no: :change }
      hash_diff = ObjectDiff::Hash.new( old, new )
      expect { making_a_change_to_hash(new) }.to_not change { hash_diff.differences }
    end

  end

  describe "#to_s" do

    it "produces an empty string for identical hashes" do
      hash_diff = ObjectDiff::Hash.new( { no: :change }, { no: :change } )
      hash_diff.to_s.should eq( '' )
    end

    it "produces unified diff output for different hashes" do
      hash_diff = ObjectDiff::Hash.new( { change: :from }, { change: :to } )
      hash_diff.to_s.should eq( "- :change: :from\n+ :change: :to\n" )
    end

    extend ExampleFactory

    # TODO I would prefer more explicit it_fulfills_examples('spec/examples/*-test.txt')
    it_fulfills_examples('*-test.txt')

  end

end 
