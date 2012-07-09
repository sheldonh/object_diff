require 'ostruct'
require 'yaml'

class ExamplePrescription

  def initialize(prescription)
    @prescription = prescription
  end

  def input(name)
    inputs.send(name)
  end

  def inputs
    @inputs ||= OpenStruct.new(inputs_from_yaml)
  end

  def expected_output
    everything_after_dot_dot_dot
  end

  private

  def inputs_from_yaml
    YAML.load(@prescription)
  end


  def everything_after_dot_dot_dot
    @prescription.gsub(/\A.*^\.\.\.\n/m, '')
  end

end
