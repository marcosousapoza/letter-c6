#import "@local/letter-c6:0.1.0": letter, swiss-recipient, swiss-sender

#show: letter.with(
  sender: swiss-sender(
    name: "Anna Beispiel",
    street: "Bahnhofstrasse 1",
    postcode: "3000",
    town: "Bern",
  ),
  recipient: swiss-recipient(
    name: "Max Muster",
    street: "Musterstrasse 12",
    postcode: "8000",
    town: "Zürich",
  ),
  date: "Bern, 14. Juli 2026",
  subject: "Unterschriftstest",
  salutation: "Sehr geehrter Herr Muster",
  closing: "Freundliche Grüsse",
  signature-image: image("../template/signature.svg", width: 3cm),
  signature: [Anna Beispiel],
)

Dieser Brief prüft die Platzierung einer SVG-Unterschrift.
