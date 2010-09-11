module ActiveBraintree
  class Base
    include MagicAttributes

    def valid?
      @errors.empty?
    end
  end
end
