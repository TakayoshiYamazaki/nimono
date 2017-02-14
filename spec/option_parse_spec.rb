#-*- coding: utf-8 -*-
require 'spec_helper'

RSpec.describe Nimono::OptionParse do
  describe '#parse_options' do
    subject {Nimono::Cabocha.parse_options(options)}
    context '-f0' do
      let(:options) {'-f0'}
      it {is_expected.to match(:output_format => 0)}
    end
    context '-f1' do
      let(:options) {'-f1'}
      it {is_expected.to match(:output_format => 1)}
    end
    context '-f2' do
      let(:options) {'-f2'}
      it {is_expected.to match(:output_format => 2)}
    end
    context '-f3' do
      let(:options) {'-f3'}
      it {is_expected.to match(:output_format => 3)}
    end
    context '-I0' do
      let(:options) {'-I0'}
      it {is_expected.to match(:input_layer => 0)}
    end
    context '-I1' do
      let(:options) {'-I1'}
      it {is_expected.to match(:input_layer => 1)}
    end
    context '-I2' do
      let(:options) {'-I2'}
      it {is_expected.to match(:input_layer => 2)}
    end
    context '-I3' do
      let(:options) {'-I3'}
      it {is_expected.to match(:input_layer => 3)}
    end
    context '-O1' do
      let(:options) {'-O1'}
      it {is_expected.to match(:output_layer => 1)}
    end
    context '-O2' do
      let(:options) {'-O2'}
      it {is_expected.to match(:output_layer => 2)}
    end
    context '-O3' do
      let(:options) {'-O3'}
      it {is_expected.to match(:output_layer => 3)}
    end
    context '-O4' do
      let(:options) {'-O4'}
      it {is_expected.to match(:output_layer => 4)}
    end
    context '-n0' do
      let(:options) {'-n0'}
      it {is_expected.to match(:ne => 0)}
    end
    context '-n1' do
      let(:options) {'-n1'}
      it {is_expected.to match(:ne => 1)}
    end
    context '-n2' do
      let(:options) {'-n2'}
      it {is_expected.to match(:ne => 2)}
    end
    context '-m model/paser.model.txt' do
      let(:options) {'-m model/parser.model.txt'}
      it {is_expected.to match(:parser_model => 'model/parser.model.txt')}
    end
    context '-M model/dep.juman.txt' do
      let(:options) {'-M model/dep.juman.txt'}
      it {is_expected.to match(:chunker_model => 'model/dep.juman.txt')}
    end
    context '-N model/ne.model.txt' do
      let(:options) {'-N model/ne.model.txt'}
      it {is_expected.to match(:ne_model => 'model/ne.model.txt')}
    end
    context '-t EUC-JP' do
      let(:options) {'-t EUC-JP'}
      it {is_expected.to match(:charset => 'EUC-JP')}
    end
    context '-P IPA' do
      let(:options) {'-P IPA'}
      it {is_expected.to match(:posset => 'IPA')}
    end
    context '-r path/to/rcfile' do
      let(:options) {'-r path/to/rcfile'}
      it {is_expected.to match(:rcfile => 'path/to/rcfile')}
    end
    context '-b path/to/mecabrc_file' do
      let(:options) {'-b path/to/mecabrc_file'}
      it {is_expected.to match(:mecabrc => 'path/to/mecabrc_file')}
    end
    context '-o path/to/output_file' do
      let(:options) {'-o path/to/output_file'}
      it {is_expected.to match(:output => 'path/to/output_file')}
    end
  end

  # Expecting errors
  describe '#parse_options error' do
    context '-fa' do
      let(:options) {'-fa'}
      it 'expected to rise error' do
        expect {Nimono::Cabocha.parse_options(options)}.to raise_error(Nimono::CabochaError, "Invalid option: --output-format=a")
      end
    end

    context '-I4' do
      let(:options) {'-I4'}
      it 'expected to rise error' do
        expect {Nimono::Cabocha.parse_options(options)}.to raise_error(Nimono::CabochaError, "Invalid option: --input-layer=4")
      end
    end
    context '-Oa' do
      let(:options) {'-Oa'}
      it 'expected to rise error' do
        expect {Nimono::Cabocha.parse_options(options)}.to raise_error(Nimono::CabochaError, "Invalid option: --output-layer=a")
      end
    end
    context '-na' do
      let(:options) {'-na'}
      it 'expected to rise error' do
        expect {Nimono::Cabocha.parse_options(options)}.to raise_error(Nimono::CabochaError, "Invalid option: --ne=a")
      end
    end
  end

  describe '#build_options_str' do
    subject {Nimono::Cabocha.build_options_str(options)}
    context '{:output_format=>0}' do
      let(:options) {{:output_format => 0}}
      it {is_expected.to eq "--output-format=0"}
    end
    context '{:output_format=>1}' do
      let(:options) {{:output_format => 1}}
      it {is_expected.to eq "--output-format=1"}
    end
    context '{:output_format=>2}' do
      let(:options) {{:output_format => 2}}
      it {is_expected.to eq "--output-format=2"}
    end
    context '{:output_format=>3}' do
      let(:options) {{:output_format => 3}}
      it {is_expected.to eq "--output-format=3"}
    end
    context '{:input_layer=>0}' do
      let(:options) {{:input_layer => 0}}
      it {is_expected.to eq "--input-layer=0"}
    end
    context '{:input_layer=>1}' do
      let(:options) {{:input_layer => 1}}
      it {is_expected.to eq "--input-layer=1"}
    end
    context '{:input_layer=>2}' do
      let(:options) {{:input_layer => 2}}
      it {is_expected.to eq "--input-layer=2"}
    end
    context '{:input_layer=>3}' do
      let(:options) {{:input_layer => 3}}
      it {is_expected.to eq "--input-layer=3"}
    end
    context '{:output_layer=>1}' do
      let(:options) {{:output_layer => 1}}
      it {is_expected.to eq "--output-layer=1"}
    end
    context '{:output_layer=>2}' do
      let(:options) {{:output_layer => 2}}
      it {is_expected.to eq "--output-layer=2"}
    end
    context '{:output_layer=>3}' do
      let(:options) {{:output_layer => 3}}
      it {is_expected.to eq "--output-layer=3"}
    end
    context '{:output_layer=>4}' do
      let(:options) {{:output_layer => 4}}
      it {is_expected.to eq "--output-layer=4"}
    end
    context '{:ne=>0}' do
      let(:options) {{:ne => 0}}
      it {is_expected.to eq "--ne=0"}
    end
    context '{:ne=>1}' do
      let(:options) {{:ne => 1}}
      it {is_expected.to eq "--ne=1"}
    end
    context '{:ne=>2}' do
      let(:options) {{:ne => 2}}
      it {is_expected.to eq "--ne=2"}
    end
    context "{:parser_model=>'model/parser.model.txt'}" do
      let(:options) {{:parser_model => 'model/parser.model.txt'}}
      it {is_expected.to eq "--parser-model=model/parser.model.txt"}
    end
    context "{:chunker_model=>'model/dep.juman.txt'}" do
      let(:options) {{:chunker_model => 'model/dep.juman.txt'}}
      it {is_expected.to eq "--chunker-model=model/dep.juman.txt"}
    end
    context "{:ne_model=>'model/ne.model.txt'}" do
      let(:options) {{:ne_model => 'model/ne.model.txt'}}
      it {is_expected.to eq "--ne-model=model/ne.model.txt"}
    end
    context "{:charset=>'EUC-JP'}" do
      let(:options) {{:charset => 'EUC-JP'}}
      it {is_expected.to eq "--charset=EUC-JP"}
    end
    context "{:posset=>'IPA'}" do
      let(:options) {{:posset => 'IPA'}}
      it {is_expected.to eq "--posset=IPA"}
    end
    context "{:rcfile=>'path/to/rcfile'}" do
      let(:options) {{:rcfile => 'path/to/rcfile'}}
      it {is_expected.to eq "--rcfile=path/to/rcfile"}
    end
    context "{:mecabrc=>'path/to/mecabrc_file'}" do
      let(:options) {{:mecabrc => 'path/to/mecabrc_file'}}
      it {is_expected.to eq "--mecabrc=path/to/mecabrc_file"}
    end
    context "{:output=>'path/to/output_file}'" do
      let(:options) {{:output => 'path/to/output_file'}}
      it {is_expected.to eq "--output=path/to/output_file"}
    end
  end
end
