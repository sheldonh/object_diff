require 'support/example_prescription'

module ExamplePrescriptionFulfillment

  def for_each_example_prescribed_by(glob, &example_group_block)
    glob_examples_path(glob).each do |filename|
      for_the_example_prescribed_by(filename, &example_group_block)
    end
  end

  def for_the_example_prescribed_by(filename, &example_group_block)
    describe "in the example prescribed by #{relative_example_path(filename)}" do
      prescription = ExamplePrescription.new File.read(filename)
      class_exec(prescription, &example_group_block)
    end
  end

  private

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

RSpec::Core::ExampleGroup.extend ExamplePrescriptionFulfillment
