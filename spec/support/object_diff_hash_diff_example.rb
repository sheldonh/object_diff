require 'yaml'

class ObjectDiffHashDiffExample

  def initialize(example)
    @example = example
  end

  def old_hash
    example_config['old']
  end

  def new_hash
    example_config['new']
  end

  def expected_diff_string
    everything_after_dot_dot_dot
  end

  private

  def example_config
    YAML.load(@example)
  end

  def everything_after_dot_dot_dot
    @example.gsub(/\A.*^\.\.\.\n/m, '')
  end

end

