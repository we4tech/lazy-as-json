module LazyAsJson
  module AttributeFilter

    def self.included(base)
      base.respond_to?(:prepend) ?
          base.prepend(OnlyKeysFilter) :
          base.include(OnlyKeysFilter)
    end

    module OnlyKeysFilter
      # The list of excluded attribute accessor name
      BANNED_KEYS = [:all, :delete, :delete_all, :destroy_all, :destroy, :update, :save, :create,
                     :create!, :save!, :update_attributes, :update_attribute, :update_attributes!,
                     :find, :where, :increment, :increment!, :decrement, :decrement!, :remove,
                     :object_id]

      # Returns the JSON serializable hash object with the data from the specified keys.
      #
      # It Looks up for :only_keys for enabling attribute throttling, in case of absense it returns the
      # actual data from overrode 'as_json' method.
      #
      # @param opts [Hash] The additional options whether to throttle response attribute or not.
      # @return [Hash] The generated has based on the trottled keys or based on the overrode as_json method
      def as_json(opts = {})
        __set_only_keys opts.delete(:only_keys)

        __lazy_mode? ? build_as_json : super(opts)
      end

      # Sets the only keys, if you intend to use those directly instead of going through :as_json
      #
      # @return key_str [String] The attribute filtering string
      def __set_only_keys(key_str)
        @__only_keys = key_str.to_s.strip
        @__only_keys = @__only_keys.empty? ? nil : @__only_keys
      end

      # Returns the applied attribute filtering string
      #
      # @return [String] The attribute filtering string
      def __only_keys
        @__only_keys
      end

      # Creates a Hash object which lazly assembles attributes from the object or any of their parents.
      # However, it could be delegated from another object through exposing :source method.
      #
      # @return [Hash] The empty Hash object with the attribute builder closure
      def lazy_as_json(opts = {})
        Hash.new do |hash, key|
          hash[key] = _with_lazy(_find_value(key))
        end
      end

      # Returns true if the lazy mode is enabled through :only_keys option
      #
      # @return [Boolean] true if lazy mode is enabled
      def __lazy_mode?
        __only_keys && !__only_keys.empty?
      end

      # Builds the attributes hash object based on the applied attribute filtering string
      #
      # @return [Hash] The attributes based on the attribute filtering string
      def build_as_json
        @_af_references = {}
        hash            = lazy_as_json
        keys            = []

        __only_keys.split(',').each do |key|
          value = hash

          for nested_key in find_full_key(key)
            if Array === value
              value = value.map { |v| v[nested_key] }.compact
            elsif Hash === value
              value = value[nested_key]
            end
          end
        end

        hash
      end

      # Return true if the specified attribute key is not banned
      #
      # @return [Boolean] True if not listed under *BANNED_KEYS*
      def __allowed_attribute_key?(key)
        !BANNED_KEYS.include?(key)
      end

      private

      def _with_lazy(value)
        if value.respond_to?(:lazy_as_json)
          value.lazy_as_json
        elsif Array === value
          value.map { |v| v.respond_to?(:lazy_as_json) ? v.lazy_as_json : v }
        else
          value
        end
      end

      def _find_value(key)
        return unless __allowed_attribute_key?(key)

        if respond_to?(key)
          send(key)
        elsif _source_declared? && source.respond_to?(key)
          source.send(key)
        end
      end

      def _source_declared?
        @_source_declared ||= respond_to?(:source)
      end

      # Generate a fully qualified key based on it's parent object reference tree based
      # on the shortest key name.
      #
      def find_full_key(key)
        # Try to find 'actual_name(alias)' key formation
        if (matched = key.match(/^(.+)\((\w+)\)$/))
          prefixes                    = matched[1].split('.')
          @_af_references[matched[2]] =
              (wrap_array(prefixes[0, prefixes.size - 1]).
                  map { |prefix| @_af_references[prefix] } << prefixes.last.to_sym).
                  flatten
        else
          # Split key string based on the '.'
          parts    = key.split('.')

          # Traverse through all prefixes and try to find if those are aliased or not aliased
          # and build a complete reference tree.
          prefixes = parts[0, parts.size - 1].map { |prefix| @_af_references[prefix] || [] }.flatten

          # Take the actual key part
          key_part = parts.last

          # Construct the full reference tree and expand if short form is used.
          suffix   = if key_part == '_'
                       :id
                     elsif (matched = key_part.match(/^(.+)_$/))
                       :"#{matched[1]}_id"
                     else
                       key_part.to_sym
                     end

          prefixes << suffix
        end
      end

      def wrap_array(values)
        return [] if values.nil?
        return values if Array === values
        [values]
      end
    end
  end
end