#import "@local/letter-c6:0.1.0": clean-business-style, swiss-c6-left, swiss-recipient, swiss-sender

#assert(clean-business-style.font == "Liberation Sans")
#assert(clean-business-style.accent == rgb("243d60"))
#assert(clean-business-style.letterhead-fill == white)
#assert(clean-business-style.letterhead-rule == 0.45pt)

#assert(swiss-c6-left.width == 21cm)
#assert(swiss-c6-left.height == 29.7cm)
#assert(swiss-c6-left.fold-guides == (10.5cm, 21cm))
#assert(swiss-c6-left.address.x == 2cm)
#assert(swiss-c6-left.address.y == 4.5cm)
#assert(swiss-c6-left.address.width == 10cm)
#assert(swiss-c6-left.address.height == 4.5cm)
#assert(swiss-c6-left.address.inset-left == 2cm)
#assert(swiss-c6-left.address.inset-top == 1cm)
#assert(swiss-c6-left.address.inset-right == 1.2cm)

#let sample = swiss-recipient(
  title: "Herr",
  name: "Max Muster",
  street: "Musterstrasse 12",
  postcode: "8000",
  town: "Zürich",
)

#assert(sample.lines == (
  "Herr",
  "Max Muster",
  "Musterstrasse 12",
  "8000 Zürich",
))

#let sender = swiss-sender(
  name: "Anna Beispiel",
  organization: "Beispiel AG",
  street: "Bahnhofstrasse 1",
  postcode: "3000",
  town: "Bern",
  role: "Geschäftsführerin",
  phone: "+41 31 000 00 00",
  email: "anna.beispiel@example.ch",
  website: "example.ch",
)

#assert(sender.return-line == "Anna Beispiel · Bahnhofstrasse 1 · 3000 Bern")
#assert(sender.role == "Geschäftsführerin")
#assert(sender.organization == "Beispiel AG")
#assert(sender.phone == "+41 31 000 00 00")
#assert(sender.email == "anna.beispiel@example.ch")
#assert(sender.website == "example.ch")
