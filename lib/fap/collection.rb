module FAP
  class Collection
    include Enumerable

    def initialize relation, node
      @nodes = []
      @fetched = false
      @node = node
      @relation = relation
      @klass = ::FAP.constantize relation.klass
    end

    def each
      fetch_nodes unless @fetched
      @nodes.map do |node|
        obj = @klass.new nil
        obj.from_relation @relation, node
        yield obj
      end
    end

    private

      def fetch_nodes
        @nodes = @node.xpath @relation.xpath
        @fetched = true
      end
  end
end
