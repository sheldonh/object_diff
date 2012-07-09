require 'support/example_prescription'

module ExamplePrescriptionFulfillment

  shared_examples "the examples prescribed by" do |glob|
    glob_examples_path(glob).each do |filename|
      build_example_from_prescription(filename)
    end
  end

  def it_fulfills_the_examples_prescribed_by(glob)
    it_behaves_like "the examples prescribed by", glob
  end

  private

  def build_example_from_prescription(filename)
    it relative_example_path(filename) do
      prescription = ExamplePrescription.new File.read(filename)
      hash_diff = ObjectDiff::HashDiff.new( prescription.input(:old), prescription.input(:new) )
      hash_diff.unified_diff.should eq( prescription.expected_output )
    end
  end

  def glob_examples_path(glob)
    Dir.glob( File.join examples_path, glob )
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
