module Kernel
  # Stolen from Facets http://facets.rubyforge.org/  because it loads too slowly and I only want this
  def silence_warnings
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end
end

class Module
  # Stolen from Active Support because it loads too slowly and I only want this;
  # mutated wildly from there, so all bugs are mine.
  #
  # Declare an attribute accessor with an initial default return value.
  #
  # To give attribute <tt>:age</tt> the initial value <tt>25</tt>:
  #  
  #   class Person
  #     attr_accessor_with_default :age, 25
  #   end
  #
  #   some_person.age
  #   => 25
  #   some_person.age = 26
  #   some_person.age
  #   => 26
  #
  # To give attribute <tt>:element_name</tt> a dynamic default value, evaluated
  # in scope of self:
  #
  #   attr_accessor_with_default(:element_name) { name.underscore } 
  #
  ### TODO: Why doesn't this cause the proper default to return?
  # def attr_reader_from_doc_with_default(sym, default = nil, &block)
  #   puts ">>> #{sym} default: #{default.inspect}"
  #   define_method("#{sym.to_s}_from_doc".to_sym, block)
  #   module_eval(<<-EVAL, __FILE__, __LINE__)
  #     def #{sym}
  #       @#{sym} || @doc ? (@#{sym} = #{sym}_from_doc) : (#{default})
  #     end
  #   EVAL
  # end
  def attr_reader_from_doc_with_nil_default(sym, &block)
    define_method("#{sym.to_s}_from_doc".to_sym, block)
    module_eval(<<-EVAL, __FILE__, __LINE__)
      def #{sym}
        @#{sym} || @doc ? (@#{sym} = #{sym}_from_doc) : nil
      end
    EVAL
  end
  
  def attr_reader_from_doc_with_empty_array_default(sym, &block)
    define_method("#{sym.to_s}_from_doc".to_sym, block)
    module_eval(<<-EVAL, __FILE__, __LINE__)
      def #{sym}
        @#{sym} || @doc ? (@#{sym} = #{sym}_from_doc) : []
      end
    EVAL
  end
end

module Nokogiri
  module HTML
    class Document
      def %(expr)
        search(expr).first
      end
    end
  end
end