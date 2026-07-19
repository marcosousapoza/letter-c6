#import "@local/letter-c6:0.1.0": letter, swiss-recipient, swiss-sender

#let sender = swiss-sender(
  name: "Anna Beispiel",
  role: "Geschäftsführerin",
  organization: "Beispiel AG",
  street: "Bahnhofstrasse 1",
  postcode: "3000",
  town: "Bern",
  phone: "+41 31 000 00 00",
  email: "anna.beispiel@example.ch",
  website: "example.ch",
)

#let recipient = swiss-recipient(
  title: "Herr",
  name: "Max Muster",
  street: "Musterstrasse 12",
  postcode: "8000",
  town: "Zürich",
)

#show: letter.with(
  sender: sender,
  recipient: recipient,
  date: "Bern, 13. Juli 2026",
  subject: "Betreff des Schreibens",
  salutation: "Sehr geehrter Herr Muster",
  closing: "Freundliche Grüsse",
  signature-image: image("signature.svg", width: 3cm),
  signature: [Anna Beispiel],
)

Vielen Dank für Ihre Nachricht. Dieses Beispiel zeigt, wie Inhalt, Gestaltung
und die physische Positionierung für ein Schweizer C6/5-Fenstercouvert
voneinander getrennt bleiben.

Der Brieftext beginnt unterhalb des Adressfelds. Dadurch können weder Betreff
noch Anrede oder Fliesstext in das Sichtfenster hineinragen.
