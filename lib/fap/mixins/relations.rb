# For extlib_inheritable_accessor
require File.join File.dirname(__FILE__), '..', 'support', 'class'

module FAP
  module Mixins
    module Relations

      def self.included base
        base.class_eval <<-EOS, __FILE__, __LINE__ + 1
          extlib_inheritable_accessor(:relations) unless self.respond_to?(:relations)
          self.relations ||= []
        EOS
        base.extend ClassMethods
      end

      ##
      # Load a relation by its nane
      #
      # @return [FAP::Collection] for "has_many" relations
      # @return [FAP::Paw]        "father" object for "belongs_to" relations
      def _load_relation name
        relation = self.relations.select { |rel| rel.name == name }.first
        if relation.type == :has_many
          _load_has_many relation
        elsif relation.type == :belongs_to
          _load_belongs_to relation
        else
          raise "Unkown relation type"
        end
      end

      def _load_has_many relation
        relation.from = self
        FAP::Collection.new relation, @_node
      end

      def _load_belongs_to relation
        nil
      end

      module ClassMethods

        ##
        # Define a "many" relation
        #
        def has_many name, opts={}
          opts.merge! :type => :has_many, :from => self
          relation = FAP::Relation.new name, opts
          self.relations << relation
          define_relation_getter relation
        end

        ##
        # Define a "belongs to" relation
        #
        def belongs_to name, opts={}
          opts.merge! :type => :belongs_to, :from => self
          relation = FAP::Relation.new name, opts
          self.relations << relation
          define_relation_getter relation
        end

        protected
 
          ##
          # Add getter for a relation.
          #
          # @param [FAP::Relation]
          # @return TBD
          def define_relation_getter relation
            class_eval <<-EOS, __FILE__, __LINE__ + 1
              def #{relation.name}
                if @_cache[:#{relation.name}]
                  @_cache[:#{relation.name}]
                else
                  @_cache[:#{relation.name}] = _load_relation :#{relation.name}
                end
              end
            EOS
          end
      end

    end
  end
end
