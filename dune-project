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
 (synopsis "Telegram Bot Framework")
 (depends ocaml dune tgbot-api))

(package
 (name tgbot-api)
 (synopsis "Telegram Bot API types definitions")
 (depends ocaml dune))
