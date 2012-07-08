require 'support/object_diff_hash_diff_example'

module ExampleFactory

  def it_fulfills_examples(glob)
    glob_examples_path(glob).each do |filename|
      build_example_from_file filename
    end
  end

  private

  def glob_examples_path(glob)
    Dir.glob( File.join examples_path, glob )
  end

  def build_example_from_file(filename)
    it "fulfills the example described in #{relative_example_path(filename)}" do
      example = ObjectDiffHashDiffExample.new File.read(filename)
      hash_diff = ObjectDiff::HashDiff.new( example.old_hash, example.new_hash )
      hash_diff.unified_diff.should eq( example.expected_diff_string )
    end
  end

  def relative_example_path(filename)
    Pathname.new( filename ).relative_path_from Pathname.new( project_path )
  end

  def examples_path
    File.join project_path, 'spec', 'examples'
  end

  def project_path
    File.join( File.dirname(__FILE__), '..', '..' )
  end

end
