# nimono [![Gem Version](https://badge.fury.io/rb/nimono.svg)](https://badge.fury.io/rb/nimono)

nimono is an interface of CaboCha for MRI Ruby and JRuby, and parsing Japanese
sentences using the library.
It depends on the CaboCha library so the library will have to install first.

## Requirements

nimono requires the following:

- [CaboCha _0.69_](https://taku910.github.io/cabocha/)
- [CaboCha](https://taku910.github.io/cabocha/) requires [CRF++](https://taku910.github.io/crfpp/), [MeCab](http://taku910.github.io/mecab/#download) and either of the following dictionaries.
- mecab-ipadic, mecab-jumandic, unidic. For further information please refer to the [MeCab](http://taku910.github.io/mecab/#).
- [ffi _1.9.0 or higher_](https://rubygems.org/gems/ffi)

## Installation

Install it as:

    $ gem install nimono

## Usage

Create an instance of Nimono::Cabocha and parse the sentence.
By default, the result is outpeuuted by displaying Sumple Tree.

```ruby
require 'nimono'

nc = Nimono::Cabocha.new
puts nc.parse('太郎は花子が読んでいる本を次郎に渡した')
    太郎は---------D
      花子が-D     |
    読んでいる-D   |
            本を---D
            次郎に-D
              渡した
EOS
```
Example of analyzing dependency:
```ruby
require 'nimono'

nc = Nimono::Cabocha.new('-n1')
nc.parse('太郎は花子が読んでいる本を次郎に渡した')
nc.tokens.each do |t|
  cid = 0
  unless t.chunk.nil?
    puts "* #{cid} #{t.chunk.link}D #{t.chunk.head_pos}/#{t.chunk.func_pos} #{'%6f' % t.chunk.score}"
    cid += 1
  end
  puts "#{t.surface}\t#{t.feature}\t#{t.ne}"
end

* 0 5D 0/1 -0.742128
太郎	名詞,固有名詞,人名,名,*,*,太郎,タロウ,タロー	B-PERSON
は	助詞,係助詞,*,*,*,*,は,ハ,ワ	O
* 1 2D 0/1 1.700175
花子	名詞,固有名詞,人名,名,*,*,花子,ハナコ,ハナコ	B-PERSON
が	助詞,格助詞,一般,*,*,*,が,ガ,ガ	O
* 2 3D 0/2 1.825021
読ん	動詞,自立,*,*,五段・マ行,連用タ接続,読む,ヨン,ヨン	O
で	助詞,接続助詞,*,*,*,*,で,デ,デ	O
いる	動詞,非自立,*,*,一段,基本形,いる,イル,イル	O
* 3 5D 0/1 -0.742128
本	名詞,一般,*,*,*,*,本,ホン,ホン	O
を	助詞,格助詞,一般,*,*,*,を,ヲ,ヲ	O
* 4 5D 1/2 -0.742128
次	名詞,一般,*,*,*,*,次,ツギ,ツギ	O
郎	名詞,一般,*,*,*,*,郎,ロウ,ロー	O
に	助詞,格助詞,一般,*,*,*,に,ニ,ニ	O
* 5 -1D 0/1 0.000000
渡し	動詞,自立,*,*,五段・サ行,連用形,渡す,ワタシ,ワタシ	O
た	助動詞,*,*,*,特殊・タ,基本形,た,タ,タ	O

```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TakayoshiYamazaki/nimono. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

