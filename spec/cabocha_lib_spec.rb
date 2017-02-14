#-*- coding: utf-8 -*-
require 'spec_helper'
require 'rbconfig'

RSpec.describe Nimono::CabochaLib do
  describe '#cabocha_library' do
    subject {Nimono::CabochaLib.cabocha_library}
    host_os = RbConfig::CONFIG['host_os']
    if host_os =~ /mswin|mingw|mingw32/i
      context 'when Windows' do
        it {is_expected.to match(%r{libcabocha.dll$})}
      end
    elsif host_os =~ /darwin/i
      context 'when macOS' do
        it {is_expected.to match(%r{libcabocha.dylib$})}
      end
    elsif host_os =~ /linux/i
      context 'when Linux' do
        it {is_expected.to match(%r{libcabocha.so$})}
      end
    end
  end
end
