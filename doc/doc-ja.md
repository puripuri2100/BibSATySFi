bibsatysfi v0.1.0

このソフトウェアはbibファイルを、SATySFiのパッケージの1つである[BiByFi](https://github.com/namachan10777/BiByFi)で処理できるデータ構造に書き換えるものです。

事前にBiByFiを`dist/packages/bibyfi/`以下にインストールしてください。

リポジトリは https://github.com/puripuri2100/BibSATySFi で、MITライセンスの元公開されています。

# インストール

- OPAMをインストールします
```
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
```
で入ります。
- OCamlをインストールします
```
opam init --comp 4.10.0

eval $(opam env)
```
などとすると良いでしょう（Ubuntu on WSLえを使っている人は`opam init`の際に`--disable-sandboxing`というオプションをつけてください）。
バージョンは古すぎなければ大体のもので動くと思われます。
- リポジトリをクローンしてビルドする
```
git clone https://github.com/puripuri2100/BibSATySFi.git
cd BibSATySFi
opam pin add bibsatysfi .
opam install bibsatysfi
```
でビルドができ、インストールも完了します。


# 使い方

## 使う前の注意

手元にあるbibファイルの中で、値を表す際に中括弧(`{}`)を使っている場合には全てダブルコーテーション(`""`)に書き換える必要があります。

例えば、

```
@Book{rust2019,
  author = {κeen, 河野達也 and 小松礼人},
  title = {実践Rust入門},
  publisher = {技術評論社},
  year = {2019}
}
```

という風に書いてあったら、これを

```
@Book{"rust2019",
  author = "κeen, 河野達也 and 小松礼人",
  title = "実践Rust入門",
  publisher = "技術評論社",
  year = 2019
}
```

という風に書き換える必要があります。数字についてはダブルクォーテーションで表しても表さなくても大丈夫です。

また、LaTeXコマンドの類は一切使えません。適宜削除や書き直しをしてください。

## コマンドの起動の仕方

```
bibsatysfi -f 〈bibファイル〉 -o 〈satyhファイル〉
```

です。

ファイル名は絶対パスと相対パスのどちらも使えます。
