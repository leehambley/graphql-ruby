# frozen_string_literal: true

module GraphQL
  module Tracing
    class ScoutTracing < PlatformTracing
      INSTRUMENT_OPTS = { scope: true }

      self.platform_keys = {
        "lex" => "lex.graphql",
        "parse" => "parse.graphql",
        "validate" => "validate.graphql",
        "analyze_query" => "analyze.graphql",
        "analyze_multiplex" => "analyze.graphql",
        "execute_multiplex" => "execute.graphql",
        "execute_query" => "execute.graphql",
        "execute_query_lazy" => "execute.graphql",
      }

      def initialize
        self.class.include ScoutApm::Tracer
        super
      end

      def platform_trace(platform_key, key, data)
        self.class.instrument("GraphQL", platform_key, INSTRUMENT_OPTS) do
          yield
        end
      end

      def platform_field_key(type, field)
        "#{type.name}.#{field.name}"
      end
    end
  end
end