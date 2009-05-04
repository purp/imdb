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
  def cached_attr_reader_from_doc_with_default(sym, opts)
    define_method("#{sym}_from_doc") do
      node = @doc.search(opts[:expr]).first
      opts[:post].call(node) if node
    end

    define_method(sym) do
      instance_variable_get("@#{sym}") || (@doc ? instance_variable_set("@#{sym}", self.send("#{sym}_from_doc")) : opts[:default])
    end
  end

  def generate_cached_attr_readers(hash)
    hash.each do |sym, opts|
      cached_attr_reader_from_doc_with_default(sym, hash[sym])
    end
  end    
end
