#-*- coding: utf-8 -*-
require "spec_helper"

describe Nimono do
  it "has a version number" do
    expect(Nimono::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end
end

describe Nimono::Cabocha do
  before do
    @nc = Nimono::Cabocha.new
  end

  it '#parse' do
    text = "太郎は花子が読んでいる本を次郎に渡した"
    expect(@nc.parse(text)).to eq ("    太郎は---------D\n      花子が-D     \
|\n    読んでいる-D   |\n            本を---D\n            次郎に-D\n        \
      渡した\nEOS\n")
  end

  # ファイルからテキスト読み込み
  it '#parse from text file' do
    nc = Nimono::Cabocha.new('-f1 -n1')
    fname = '/home/yamazaki/work/nimono/spec/sports.data'
    File.foreach(fname) do |line|
      expect(nc.parse(line)).to eq ("* 0 1D 3/4 0.000000\n［\t記号,括弧開,*,*,*,*,［,［,［\tO\nスポーツ\t名詞,一般,*,*,*,*,スポーツ,スポーツ,スポーツ\tO\n］\t記号,括弧閉,*,*,*,*,］,］,］\tO\n私\t名詞,代名詞,一般,*,*,*,私,ワタシ,ワタシ\tO\nの\t助詞,連体化,*,*,*,*,の,ノ,ノ\tO\n* 1 -1D 0/0 0.000000\n生きがい\t名詞,一般,*,*,*,*,生きがい,イキガイ,イキガイ\tO\nEOS\n")
    end
  end


  #it '#parse with option --parser-model=FILE' do

  # modelファイル読み込み
  it '#parse with option --chunker-model=FILE' do
    fname = File.join(File.dirname(File.expand_path(__FILE__)), '/chunk.model')

    nc = Nimono::Cabocha.new("-M #{fname} -f1")
    text = '今の１回生では１番漕暦が浅いのに持ち前の体力と精神力でレース出場権を手にした。'
    expect(nc.parse(text)).to eq ("* 0 1D 0/1 1.394607\n今\t名詞,副詞可能,*,*,*,*,今,イマ,イマ\nの\t助詞,連体化,*,*,*,*,の,ノ,ノ\n* 1 4D 1/3 0.452741\n１\t名詞,数,*,*,*,*,１,イチ,イチ\n回生\t名詞,接尾,助数詞,*,*,*,回生,カイセイ,カイセイ\nで\t助動詞,*,*,*,特殊・ダ,連用形,だ,デ,デ\nは\t助詞,係助詞,*,*,*,*,は,ハ,ワ\n* 2 4D 1/1 1.253141\n１\t名詞,数,*,*,*,*,１,イチ,イチ\n番\t名詞,接尾,助数詞,*,*,*,番,バン,バン\n* 3 4D 0/1 1.352040\n漕暦\t名詞,固有名詞,組織,*,*,*,*\nが\t助詞,格助詞,一般,*,*,*,が,ガ,ガ\n* 4 11D 0/1 -2.085799\n浅い\t形容詞,自立,*,*,形容詞・アウオ段,基本形,浅い,アサイ,アサイ\nのに\t助詞,接続助詞,*,*,*,*,のに,ノニ,ノニ\n* 5 7D 0/1 1.386476\n持ち前\t名詞,一般,*,*,*,*,持ち前,モチマエ,モチマエ\nの\t助詞,連体化,*,*,*,*,の,ノ,ノ\n* 6 7D 0/1 1.431734\n体力\t名詞,一般,*,*,*,*,体力,タイリョク,タイリョク\nと\t助詞,並立助詞,*,*,*,*,と,ト,ト\n* 7 11D 1/2 -2.085799\n精神\t名詞,一般,*,*,*,*,精神,セイシン,セイシン\n力\t名詞,接尾,一般,*,*,*,力,リョク,リョク\nで\t助詞,格助詞,一般,*,*,*,で,デ,デ\n* 8 9D 1/1 0.353739\nレース\t名詞,一般,*,*,*,*,レース,レース,レース\n出場\t名詞,サ変接続,*,*,*,*,出場,シュツジョウ,シュツジョー\n* 9 11D 0/1 -2.085799\n権\t名詞,接尾,一般,*,*,*,権,ケン,ケン\nを\t助詞,格助詞,一般,*,*,*,を,ヲ,ヲ\n* 10 11D 0/1 -2.085799\n手\t名詞,一般,*,*,*,*,手,テ,テ\nに\t助詞,格助詞,一般,*,*,*,に,ニ,ニ\n* 11 -1D 0/1 0.000000\nし\t動詞,自立,*,*,サ変・スル,連用形,する,シ,シ\nた\t助動詞,*,*,*,特殊・タ,基本形,た,タ,タ\n。\t記号,句点,*,*,*,*,。,。,。\nEOS\n")
  end

  # it '#parse with option --ne-model=FILE' do
  # it '#parse with option --posset=STR' do
  # it '#parse with option --charset=ENC' do
  # it '#parse with option --charset-file=FILE' do
  # it '#parse with option --rcfile=FILE' do
  # it '#parse with option --mecabrc=FILE' do
  # it '#parse with option --mecab-dicdir=DIR' do
  # it '#parse with option --output=FILE' do

end
