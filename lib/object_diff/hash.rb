#!/usr/bin/env ruby

require 'object_diff/difference'

module ObjectDiff

  class Hash

    def initialize(old, new)
      @old = old
      @new = new
      @differences = nil
    end

    def different?
      not differences.empty?
    end

    def to_s
      differences.collect { |o| "#{o}\n" }.join
    end

    def differences
      calculate_differences_if_first_time
      @differences
    end

    private

    def calculate_differences_if_first_time
      if @differences.nil?
        @differences = []
        calculate_differences
      end
    end

    def calculate_differences
      keys_from_both_hashes.each do |key|
        @key = key
        handle_differences_for_key
      end
    end

    def handle_differences_for_key
      handle_removal_for_key or handle_addition_for_key or handle_change_for_key
    end

    def handle_removal_for_key
      if key_removed?
        add_removal_for_key
      end
    end

    def handle_addition_for_key
      if key_added?
        add_addition_for_key
      end
    end

    def handle_change_for_key
      if key_value_changed?
        add_change_for_key
      end
    end

    def key_removed?
      @old.include?(@key) and not @new.include?(@key)
    end

    def key_added?
      @new.include?(@key) and not @old.include?(@key)
    end

    def key_value_changed?
      old_value != new_value
    end

    def add_removal_for_key
      @differences << Removal.new(@key, old_value)
    end

    def add_addition_for_key
      @differences << Addition.new(@key, new_value)
    end

    def add_change_for_key
      @differences << Removal.new(@key, old_value)
      @differences << Addition.new(@key, new_value)
    end

    def keys_from_both_hashes
      @old.keys.concat( @new.keys ).sort.uniq
    end

    def old_value
      @old[@key]
    end

    def new_value
      @new[@key]
    end

  end

end
