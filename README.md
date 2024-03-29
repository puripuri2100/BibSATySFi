![](https://github.com/puripuri2100/BibSATySFi/workflows/CI/badge.svg)


# BibSATySFi

This software converts bib file to SATySFi's document file.


# Install using OPAM

Here is a list of minimally required softwares.

* git
* make
* [opam](https://opam.ocaml.org/) 2.0
* ocaml (>= 4.06.0) (installed by OPAM)


## Example

### Install opam (Ubuntu)

```sh
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)

eval $(opam env)
```

### Install ocaml (Ubuntu)

```sh
opam init --comp 4.10.0
```

### Install ocaml (Ubuntu on WSL1)

```sh
opam init --comp 4.10.0 --disable-sandboxing
```

### Build

```sh
git clone https://github.com/puripuri2100/BibSATySFi.git
cd BibSATySFi

opam pin add bibsatysfi .
opam install bibsatysfi
```


# Usage of bibsatysfi

Required package

- [BiByFi](https://github.com/namachan10777/BiByFi)


Type

```sh
bibsatysfi <input file> -o <output file>
```

---

This software released under [the MIT license](https://github.com/puripuri2100/BibSATySFi/blob/master/LICENSE).

Copyright (c) 2020 Naoki Kaneko (a.k.a. "puripuri2100")
