require 'gherkin/i18n'
require 'gherkin/native'

module Gherkin
  module Lexer
    I18nLexerNotFound = Class.new(LoadError)
    LexingError = Class.new(StandardError)

    # The main entry point to lexing Gherkin source.
    class I18nLexer
      native_impl('gherkin')

      COMMENT_PATTERN = /^\s*#/
      LANGUAGE_PATTERN = /^\s*#\s*language\s*:\s*([a-zA-Z\-]+)/ #:nodoc:
      attr_reader :i18n_language

      def initialize(listener, force_ruby=false)
        @listener = listener
        @force_ruby = force_ruby
      end

      def scan(source)
        create_delegate(source).scan(source)
      end

    private

      def create_delegate(source)
        @i18n_language = lang(source)
        @i18n_language.lexer(@listener, @force_ruby)
      end

      def lang(source)
        lang = 'en'
        source.split(/\n/).each do |line|
          break unless COMMENT_PATTERN =~ line
          if LANGUAGE_PATTERN =~ line
            lang = $1
            break
          end
        end
        I18n.get(lang)
      end

    end
  end
end
