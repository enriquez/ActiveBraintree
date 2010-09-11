module ActiveBraintree
  module MagicAttributes
    def self.included(base)
      base.extend(ClassMethods)
    end

    protected

    def attributes
      self.class.attrs
    end

    def set_attributes(result, opts = { :except => [] })
      (attributes - opts[:except]).each do |attr|
        instance_variable_set("@#{attr}".to_sym, result.send(attr))
      end
    end

    module ClassMethods
      def attributes(*attrs)
        @attrs ||= []
        @attrs.concat attrs
        attr_reader(*attrs)
      end

      def attrs
        @attrs
      end
    end
  end
end
