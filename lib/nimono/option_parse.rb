#-*- coding: utf-8 -*-
module Nimono

  # Module 'OptionParse' encapsulates methods and behavior
  # for parsing the various CaboCha options supported by 'Nimono'.
  module OptionParse
    require 'optparse'

    # Supported CaboCha command line options are as follows.
    # For further information please refer to CaboCha help.
    SUPPORT_OPTS = {
      '-f' => :output_format,
      '-I' => :input_layer,
      '-O' => :output_layer,
      '-n' => :ne,
      '-m' => :parser_model,
      '-M' => :chunker_model,
      '-N' => :ne_model,
      '-P' => :posset,
      '-t' => :charset,
      '-T' => :charset_file,
      '-r' => :rcfile,
      '-b' => :mecabrc,
      '-d' => :mecab_dicdir,
      '-u' => :mecab_userdic,
      '-o' => :output
    }.freeze

    # @private
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    # @private
    module ClassMethods

      # Preparesand returns a hash mapping symbols for the specified,
      # recognized CaboCha options, and their values. Will parse and
      # convert string (short or long argument styles) or hash.
      def parse_options(options={})
        opts = {}
        if options.is_a? String
          opt = OptionParser.new
          opt.on('-f', '--output-format=VAL') {|v| opts[:output_format] = v.strip }
          opt.on('-I', '--input-layer=VAL') {|v| opts[:input_layer] = v.strip }
          opt.on('-O', '--output-layer=VAL') {|v| opts[:output_layer] = v.strip }
          opt.on('-n', '--ne=VAL') {|v| opts[:ne] = v.strip }
          opt.on('-m', '--parser-model=VAL') {|v| opts[:parser_model] = v.strip }
          opt.on('-M', '--chunker-model=VAL') {|v| opts[:chunker_model] = v.strip }
          opt.on('-N', '--ne-model=VAL') {|v| opts[:ne_model] = v.strip }
          opt.on('-P', '--posset=VAL') {|v| opts[:posset] = v.strip }
          opt.on('-t', '--charset=VAL') {|v| opts[:charset] = v.strip }
          opt.on('-T', '--charset-file=VAL') {|v| opts[:posset] = v.strip }
          opt.on('-r', '--rcfile=VAL') {|v| opts[:rcfile] = v.strip }
          opt.on('-b', '--mecabrc=VAL') {|v| opts[:mecabrc] = v.strip }
          opt.on('-d', '--mecab-dicdir=VAL') {|v| opts[:posset] = v.strip }
          opt.on('-u', '--mecab-userdic=VAL') {|v| opts[:posset] = v.strip }
          opt.on('-o', '--output=VAL') {|v| opts[:output] = v.strip }
          opt.parse!(options.split)
        else
          SUPPORT_OPTS.values.each do |k|
            if options.has_key?(k)
              opts[k] = options[k]
            end
          end
        end

        # validation
        validate_numeric = ->(name, pattern) {
          if opts.has_key?(name)
            if opts[name].is_a?(String) && opts[name] =~ pattern
              opts[name] = opts[name].to_i
            elsif opts[name].is_a?(Fixnum) && opts[name].to_s =~ pattern
            else
              v = opts[name]
              name_str = name.id2name.gsub('_', '-')
              raise CabochaError.new("Invalid option: --#{name_str}=#{v}")
            end
          end
        }

        validate_numeric.(:output_format, /^[0-4]$/)
        validate_numeric.(:input_layer,   /^[0-3]$/)
        validate_numeric.(:output_layer,  /^[1-4]$/)
        validate_numeric.(:ne,            /^[0-2]$/)

        opts
      end

      # Returns a string representation of the options to
      # be passed in the construction of the CaboCha Paser.
      # @param options[Hash] options for CaboCha
      # @return [String] representation of the options to the CaboCha Parser
      def build_options_str(options={})
        opt = []
        SUPPORT_OPTS.values.each do |k|
          if options.has_key? k
            key = k.to_s.gsub('_', '-')
            opt << "--#{key}=#{options[k]}"
          end
        end
        opt.empty? ? '' : opt.join(" ")
      end
    end
  end
end
