(lang dune 3.16)

(name tgbot)

(generate_opam_files true)

(source
 (github dx3mod/tgbot))

(authors "Mikhail Lopatin <dx3mod@bk.ru>")

(maintainers "Mikhail Lopatin <dx3mod@bk.ru>")

(license MIT)

(package
 (name tgbot)
 (synopsis "Telegram Bot framework")
 (description "A modern framework for Telegram Bot API")
 (depends
  (ocaml
   (>= 5.0))
  dune
  yojson
  ppx_deriving
  ppx_yojson_conv
  eio
  cohttp-eio
  tls-eio
  ca-certs
  mirage-crypto-rng-eio)
 (tags
  (telegram network)))
