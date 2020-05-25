bibsatysfi v0.1.0

このソフトウェアはbibファイルを、SATySFiのパッケージの1つである[BiByFi](https://github.com/namachan10777/BiByFi)で処理できるデータ構造に書き換えるものです。

BiByFiを`dist/packages/bibyfi/`以下にインストールしてください。

# 注意事項

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
