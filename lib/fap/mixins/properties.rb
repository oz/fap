# For extlib_inheritable_accessor
require File.join File.dirname(__FILE__), '..', 'support', 'class'

module FAP
  module Mixins
    module Properties

      def self.included base
        base.class_eval <<-EOS, __FILE__, __LINE__ + 1
          extlib_inheritable_accessor(:properties) unless self.respond_to?(:properties)
          self.properties ||= []
        EOS
        base.extend ClassMethods
      end

      def _search_property name
        property = properties.select { |prop| prop.name == name }.first
        node = @_node.at_xpath property.xpath
        raise StandardError, "Could not find #{self.class}.#{name} (#{property.xpath}) in stream." unless node
        property.cast node
      end

      module ClassMethods

        ##
        # Define a new property.
        #
        #   property :foo, "String", :some => "options"
        #   property :foo
        #   property :foo, :some => "options"
        #
        # @param [Symbol] property name
        # @param [Array]  splat args
        def property name, *args
          opts = {}
          opts.merge!(:type => args.shift) if args[0].class == String
          opts.merge!(*args) unless args.empty?
          property = FAP::Property.new name, opts
          self.properties << property
          define_property_getter property
        end

        def string name, *args
          property name, *args
        end

        def number name, *args
          property name, 'Fixnum', *args
        end
        alias :integer :number

        def date name, *args
          property name, 'DateTime', *args
        end
        alias :time :date

        def uri name, *args
          property name, 'URI', *args
        end

        protected

          def define_property_getter property
            class_eval <<-EOS, __FILE__, __LINE__ + 1
              def #{property.name}
                if @_cache[:#{property.name}]
                  @_cache[:#{property.name}]
                else
                  @_cache[:#{property.name}] = _search_property :#{property.name}
                end
              end
            EOS
          end
      end
    end
  end
end
