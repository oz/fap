#!/usr/bin/env ruby

module FAP
  class FAP

    def self.inherited subclass
      subclass.send :include, ::FAP::Mixins::Properties
      subclass.send :include, ::FAP::Mixins::Relations
      subclass.class_eval <<-EOS, __FILE__, __LINE__ + 1
        def self.inherited subclass
          super
          subclass.properties = self.properties.dup
          subclass.relations  = self.relations.dup
        end
      EOS
    end

    def initialize stream, opts={}
      data = stream.respond_to?(:read) ? stream.read : stream.to_s
      @_node = Nokogiri data
      @_cache = {}
    end

    ##
    # Build object starting from a relation's node
    #
    # @see FAP::Collection
    # @param [FAP::Relation] Object relation
    # @param [Nokogiri::XML::Element] starting node
    # @retun [FAP::FAP]
    def from_relation relation, node
      relation.from.class
      owners = self.relations.select { |rel| rel.type == :belongs_to && rel.klass == relation.from.class.to_s }
      @_cache ||= {}
      @_cache[owners.first.name] = relation.from if owners.size == 1
      @_node = node
      self
    end

  end
end
