require 'set'

module Dry
  module AutoInject
    # @api private
    class MethodParameters
      PASS_THROUGH = [[:rest]]

      attr_reader :parameters

      def initialize(parameters)
        @parameters = parameters
      end

      def splat?
        return @splat if defined? @splat
        @splat = parameters.any? { |type, _| type == :rest }
      end

      def sequential_arguments?
        return @sequential_arguments if defined? @sequential_arguments
        @sequential_arguments = parameters.any? { |type, _|
          type == :req || type == :opt
        }
      end

      def keyword_names
        @keyword_names ||= parameters.each_with_object(Set.new) { |(type, name), names|
          names << name if type == :key || type == :keyreq
        }
      end

      def keyword?(name)
        keyword_names.include?(name)
      end

      def empty?
        parameters.empty?
      end

      def length
        parameters.length
      end

      def pass_through?
        parameters.eql?(PASS_THROUGH)
      end

      EMPTY = new([]).freeze
    end
  end
end