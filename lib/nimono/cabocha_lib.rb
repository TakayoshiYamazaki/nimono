#-*- coding: utf-8 -*-
module Nimono

  # Module `CabochaLib` is a ruby extension for CaboCha libraries using Ruby-FFI.
  module CabochaLib
    require 'ffi'
    extend FFI::Library

    CABOCHA_PATH = 'CABOCHA_PATH'.freeze

    # @private
    def self.included(klass)
      klass.extend ClassMethods
    end

    # Returns the absolute path to the CaboCha library.
    # @return [String] absolute path to the CaboCha library
    def self.cabocha_library
      if ENV[CABOCHA_PATH]
        File.absolute_path(ENV[CABOCHA_PATH])
      else
        host_os = RbConfig::CONFIG['host_os'].downcase

        lib_name = case host_os
                   when /mswin|mingw/ # /mswin|msys|mingw|cygwin|bccwin|wince|emc/
                     require 'win32/registry'
                     begin
                       path = nil
                       Win32::Registry::HKEY_CURRENT_USER.open('Software\Cabocha') {|r| path = r['cabocharc'].split('etc').first}
                       File.join(path, "bin\\libcabocha.dll")
                     rescue
                       raise LoadError, "Please set #{CABOCHA_PATH} to the full path to libcabocha.dll"
                     end
                   when /darwin/, /linux/, /solaris|bsd/
                     require 'open3'
                     host_os =~ /darwin/ ? ext = 'dylib' : ext = 'so'
                     begin
                       Open3.popen3('cabocha-config --libs') {|i, o, e, t|
                         i.close
                         tokens = o.read.split
                         File.absolute_path(File.join(tokens[0][2..-1], "lib#{tokens[1][2..-1]}.#{ext}"))
                       }
                     rescue
                       raise LoadError, "Please set #{CABOCHA_PATH} to the full path to libcabocha.#{ext}"
                     end
                   else
                     raise CabochaError.new "unknown os: #{host_os.inspect}"
                   end
      end
    end

    begin
      ffi_lib cabocha_library
    rescue LoadError => e
      raise LoadError, "Faild to load CaboCha Library, patches appreciated! (#{e.message})"
    end

    # parser interfaces
    attach_function :cabocha_new2, [:string], :pointer
    attach_function :cabocha_destroy, [:pointer], :void
    # attach_function :cabocha_parse_tree, [:pointer, :pointer], :pointer
    attach_function :cabocha_sparse_tostr, [:pointer, :pointer], :string
    attach_function :cabocha_sparse_totree, [:pointer, :pointer], :pointer

    # tree interfaces
    # attach_function :cabocha_tree_new, [], :pointer
    attach_function :cabocha_tree_destroy, [:pointer], :void
    # attach_function :cabocha_tree_set_output_layer, [:pointer, :int], :void
    attach_function :cabocha_tree_tostr, [:pointer, :int], :string
    attach_function :cabocha_tree_size, [:pointer], :size_t
    attach_function :cabocha_tree_chunk_size, [:pointer], :size_t
    attach_function :cabocha_tree_token_size, [:pointer], :size_t
    attach_function :cabocha_tree_token, [:pointer, :size_t], :pointer
    attach_function :cabocha_tree_chunk, [:pointer, :size_t], :pointer
    # attach_function :cabocha_tree_charset, [:pointer], :int
    # attach_function :cabocha_tree_posset, [:pointer], :int


    # @private
    module ClassMethods
      def cabocha_library
        Nimono::CabochaLib.cabocha_library
      end
      # Create parser
      # @param opt_str [String] the option for CaboCha
      def cabocha_new2(opt_str)
        Nimono::CabochaLib.cabocha_new2(opt_str)
      end
      # Destroy parser
      # @param pptr [#parser] parser instance #parser
      def cabocha_destroy(pptr)
        Nimono::CabochaLib.cabocha_destroy(pptr)
      end

      # def cabocha_parse_tree(pptr, tptr)
      #   Nimono::CabochaLib.cabocha_parse_tree(pptr, tptr)
      # end

      # Create tree
      # @param pptr [#parser] instance of parser #parser
      # @param sptr [String] text for parsing
      def cabocha_sparse_tostr(pptr, sptr)
        Nimono::CabochaLib.cabocha_sparse_tostr(pptr, sptr)
      end

      def cabocha_sparse_totree(pptr, sptr)
        Nimono::CabochaLib.cabocha_sparse_totree(pptr, sptr)
      end

      # tree
      # def cabocha_tree_new
      #   Nimono::CabochaLib.cabocha_tree_new
      # end

      # def cabocha_tree_destroy(tptr)
      #   Nimono::CabochaLib.cabocha_tree_destroy(tptr)
      # end

      # def cabocha_tree_set_output_layer(tptr, n)
      #   Nimono::CabochaLib.cabocha_tree_set_output_layer(tptr, n)
      # end

      def cabocha_tree_tostr(tptr, n)
        Nimono::CabochaLib.cabocha_tree_tostr(tptr, n)
      end

      def cabocha_tree_size(tptr)
        Nimono::CabochaLib.cabocha_tree_size(tptr)
      end

      def cabocha_tree_chunk_size(tptr)
        Nimono::CabochaLib.cabocha_tree_chunk_size(tptr)
      end

      def cabocha_tree_token_size(tptr)
        Nimono::CabochaLib.cabocha_tree_token_size(tptr)
      end

      # # convert Tree to Sentence
      # def cabocha_tree_sentence(tptr)
      #   Nimono::CabochaLib.cabocha_tree_sentence(tptr)
      # end

      #
      # @param [#tree] tree instance tree
      # @param [Fixnum] 
      def cabocha_tree_token(tptr, n)
        Nimono::CabochaLib.cabocha_tree_token(tptr, n)
      end

      def cabocha_tree_chunk(tptr, n)
        Nimono::CabochaLib.cabocha_tree_chunk(tptr, n)
      end

      # def cabocha_tree_charset(tptr)
      #   Nimono::CabochaLib.cabocha_tree_charset(tptr)
      # end

      # def cabocha_tree_posset(tptr)
      #   Nimono::CabochaLib.cabocha_tree_posset(tptr)
      # end

    end
  end


  # 'Chunk' is a wrapper class for the 'cabocha_chunk_t' structure.
  class Chunk < FFI::Struct
    attr_reader :link
    attr_reader :head_pos
    attr_reader :func_pos
    attr_reader :token_size
    attr_reader :token_pos
    attr_reader :score
    attr_reader :feature_list
    attr_reader :additional_info
    attr_reader :feature_list_size

    # :features is a hash of elements of :feature_list separated by colons.
    attr_reader :features
    attr_reader :tokens

    layout :link, :int,
           :head_pos, :size_t,
           :func_pos, :size_t,
           :token_size, :size_t,
           :token_pos, :size_t,
           :score, :float,
           :feature_list, :pointer,
           :additional_info, :string,
           :feature_list_size, :ushort

    def initialize(lptr)
      super(lptr)
      @pointer = lptr
      if self[:additional_info]
        @additional_info = self[:additional_info].force_encoding(Encoding.default_external)
      end
      if self[:link]
        @link = self[:link]
      end
      if self[:head_pos]
        @head_pos = self[:head_pos]
      end
      if self[:func_pos]
        @func_pos = self[:func_pos]
      end
      if self[:token_size]
        @token_size = self[:token_size]
      end
      if self[:token_pos]
        @token_pos = self[:token_pos]
      end
      if self[:score]
        @score = self[:score]
      end
      if self[:feature_list_size]
        @feature_list_size = self[:feature_list_size]
      end

      if self[:feature_list_size] < 0
        raise CabochaError.new "Feature list size error"
      else
        if self[:feature_list].null?
          @feature_list = [].freeze
        else
          @feature_list = self[:feature_list].get_array_of_string(0, self[:feature_list_size]).each{|s| s.force_encoding(Encoding.default_external)}.freeze

          # create a new hash from @feature_list
          @features = Hash[*@feature_list.map {|f| f.split(':') }.flatten].freeze
        end
      end
    end
  end

  # 'Token' is a wrapper class for the 'cabocha_token_t' structure.
  class Token < FFI::Struct
    attr_reader :surface
    attr_reader :normalized_surface
    attr_reader :feature
    attr_reader :feature_list
    attr_reader :feature_list_size
    attr_reader :ne
    attr_reader :additional_info
    attr_reader :chunk

    attr_reader :pos
    attr_reader :pos1
    attr_reader :pos2
    attr_reader :pos3
    attr_reader :c_form
    attr_reader :c_type
    attr_reader :o_form
    attr_reader :reading
    attr_reader :pronunciation

    layout :surface, :string,
           :normalized_surface, :string,
           :feature, :string,
           :feature_list, :pointer,
           :feature_list_size, :ushort,
           :ne, :string,
           :additional_info, :string,
           :chunk, :pointer

    def initialize(lptr)
      super(lptr)
      @pointer = lptr
      if self[:surface]
        @surface = self[:surface].force_encoding(Encoding.default_external)
      end
      if self[:normalized_surface]
        @normalized_surface = self[:normalized_surface].force_encoding(Encoding.default_external)
      end
      if self[:feature]
        @feature = self[:feature].force_encoding(Encoding.default_external)
      end
      if self[:feature_list_size]
        @feature_list_size = self[:feature_list_size]
      end
      if self[:ne]
        @ne = self[:ne].force_encoding(Encoding.default_external)
      end
      if self[:additional_info]
        @additional_info = self[:additional_info].force_encoding(Encoding.default_external)
      end
      if self[:chunk]
        self[:chunk].null? ? nil : @chunk = Nimono::Chunk.new(self[:chunk])
      end

      if self[:feature_list_size] < 0
        raise CabochaError.new "Feature list size error"
      else
        if self[:feature_list].null?
          @feature_list = [].freeze
        else
          @feature_list = self[:feature_list].get_array_of_string(0, self[:feature_list_size]).each{|s| s.force_encoding(Encoding.default_external)}.freeze
        end
      end

      @pos           = @feature_list[0]
      @pos1          = @feature_list[1]
      @pos2          = @feature_list[2]
      @pos3          = @feature_list[3]
      @c_form        = @feature_list[4]
      @c_type        = @feature_list[5]
      @o_form        = @feature_list[6]
      @reading       = @feature_list[7]
      @pronunciation = @feature_list[8]
    end

    def to_s
      @surface
    end
  end

end
