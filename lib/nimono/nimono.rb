#-*- coding: utf-8 -*-
require 'nimono/option_parse'
require 'nimono/cabocha_lib'
require 'nimono/version'

module Nimono

  # `Cabocha` is a class providing an interface to the CaboCha library.
  # In this class the arguments supported by CaboCha can be used in almost
  # the same way.
  class Cabocha < FFI::AutoPointer
    include Nimono::OptionParse
    include Nimono::CabochaLib

    # @return [Hash] CaboCha options as Key-Value pairs
    attr_reader :options
    # @return [String] absolute file path to CaboCha library
    attr_reader :libpath
    # @return [Array] Array of chunk
    attr_reader :chunks
    # 
    # @return [Array] Array of Token
    attr_reader :tokens

    def self.release(ptr)
      self.class.cabocha_destroy(ptr)
    end

    # Initializes the CaboCha with the given 'options'.
    # options is given as a string (CaboCha command line arguments) or
    # as a Ruby-style hash.
    #
    # Options supported are:
    #
    # - :output_format
    # - :input_layer
    # - :output_layer
    # - :ne
    # - :parser_model
    # - :chunker_model
    # - :ne_model
    # - :posset
    # - :charset
    # - :charset_file
    # - :rcfile
    # - :mecabrc
    # - :mecab_dicdir
    # - :mecab_userdic
    # - :output
    #
    # <p>CaboCha command line arguments (-f1) or long (--output-format=1) may
    # be used in addition ot Ruby-style hashs</p>
    #
    # e.g.<br />
    #
    #   require 'nimono'
    #
    #   nc = Nimono::Cabocha.new(output_format: 1)
    #   or nc = Nimono::Cabocha.new('-f1')
    #
    #   => #<Nimono::Cabocha:0x6364e48d
    #     @sparse_tostr=#<Proc:0x74d917f5@/home/foo/nimono/lib/nimono/nimono.rb:54 (lambda)>,
    #     @libpath="/usr/local/lib/libcabocha.so",
    #     @options={:output_format=>1},
    #     @tree=#<FFI::Pointer address=0x7f6ecc2e3790>,
    #     @parser=#<FFI::Pointer address=0x7f6ecc2e3830>>
    #
    #   puts nc.parse('太郎は花子が読んでいる本を次郎に渡した')
    #   太郎    名詞,固有名詞,人名,名,*,*,太郎,タロウ,タロー
    #   は      助詞,係助詞,*,*,*,*,は,ハ,ワ
    #   * 1 2D 0/1 1.700175
    #   花子    名詞,固有名詞,人名,名,*,*,花子,ハナコ,ハナコ
    #   が      助詞,格助詞,一般,*,*,*,が,ガ,ガ
    #   * 2 3D 0/2 1.825021
    #   読ん    動詞,自立,*,*,五段・マ行,連用タ接続,読む,ヨン,ヨン
    #   で      助詞,接続助詞,*,*,*,*,で,デ,デ
    #   いる    動詞,非自立,*,*,一段,基本形,いる,イル,イル
    #   * 3 5D 0/1 -0.742128
    #   本      名詞,一般,*,*,*,*,本,ホン,ホン
    #   を      助詞,格助詞,一般,*,*,*,を,ヲ,ヲ
    #   * 4 5D 1/2 -0.742128
    #   次      名詞,一般,*,*,*,*,次,ツギ,ツギ
    #   郎      名詞,一般,*,*,*,*,郎,ロウ,ロー
    #   に      助詞,格助詞,一般,*,*,*,に,ニ,ニ
    #   * 5 -1D 0/1 0.000000
    #   渡し    動詞,自立,*,*,五段・サ行,連用形,渡す,ワタシ,ワタシ
    #   た      助動詞,*,*,*,特殊・タ,基本形,た,タ,タ
    #   EOS
    #   => nil
    #
    # @param options [Hash, String] the CaboCha options
    # @raise [CabochaError] if Cabocha cannot be initialized with the given 'options'
    def initialize(options={})
      @options = self.class.parse_options(options)
      opt_str = self.class.build_options_str(@options)
      @libpath = self.class.cabocha_library

      @parser = self.class.cabocha_new2(opt_str)
      super @parser

      if @parser.address == 0x0
        raise CabochaError.new("Could not initialize CaboCha with options: '#{opt_str}'")
      end
      @tree = self.class.cabocha_sparse_totree(@parser, "")

      if @options[:output_layer]
        self.class.cabocha_tree_set_output_layer(@tree, @options[:output_layer])
      end

      @sparse_tostr = ->(text) {
        begin
          self.class.cabocha_sparse_tostr(@parser, text).force_encoding(Encoding.default_external)
        rescue
          raise CabochaError.new 'Parse Error'
        end
      }
    end

    # Parses the given `text`, returning the CaboCha output as a string.
    # At the same time creating #chunks and #tokens.
    # @param text [String] the japanese text to parse
    # @return [String] parsing result from CaoboCha
    # @raise [CabochaError] if the Cabocha cannot parse the given `text`
    # @raise [ArgumentError] if the given string `text` argument is `null`
    def parse(text)
      if text.nil?
        raise CabochaError.new 'Text to parse cannot be nil'
      else
        @result = @sparse_tostr.call(text)
        @tree = self.class.cabocha_sparse_totree(@parser, text)

        @tokens = []
        self.class.cabocha_tree_token_size(@tree).times do |i|
          @tokens << Nimono::Token.new(self.class.cabocha_tree_token(@tree, i))
        end
        @tokens.freeze

        @chunks = []
        @tokens.each {|token| @chunks << token.chunk unless token.chunk.nil?}
        @chunks.each do |chunk|
          tokens = []
          chunk.token_size.times do |i|
            tokens << @tokens[chunk.token_pos + i]
          end
          chunk.instance_variable_set(:@tokens, tokens)
        end
        @chunks.freeze

        self.to_s
      end
    end

    # The result of parsing Japanese text
    # @return [String] parsing result
    def to_s
      @result
    end

  end

  class CabochaError < RuntimeError; end
end
