# letter-c6

`letter-c6` is a small Typst package for formal Swiss A4 letters folded into a
C6/5 left-window envelope. Callers supply structured sender and recipient data
plus the prose. The package owns the physical placement and business styling.

## Use

```typst
#import "@local/letter-c6:0.1.0": letter, swiss-recipient, swiss-sender

#let sender = swiss-sender(
  name: "Anna Beispiel",
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
  signature-image: image("signature.svg", width: 3cm),
  signature: [Anna Beispiel],
)

Ihr Brieftext beginnt hier.
```

The domestic recipient helper enforces a four-digit postcode without `CH-`,
does not expose a country field, and produces three to six address lines with
no inserted blank lines. Optional sender phone and email details stay in the
letterhead and outside the recipient field. The window automatically includes
a compact return-address line built from the sender organization (or name),
street, postcode, and town; callers do not repeat this information. The main
sender letterhead is styled separately in the upper-right part of the page.
Phone numbers, email addresses, and websites are emitted as `tel:`, `mailto:`,
and HTTP links in the resulting PDF.

Pass an SVG or PNG as Typst content with `signature-image:` to place it between
the closing and the printed `signature:` name. Constructing the image in the
calling document keeps its path relative to that document and lets the caller
control its size:

```typst
signature-image: image("signature.png", width: 3cm),
```

`letter` accepts `layout:` and `style:` dictionaries. The defaults are exported
as `swiss-c6-left` and `clean-business-style`, so content, styling, and physical
positioning can be changed independently. Set `debug: true` to reveal the pale
blue address alignment area. Set `fold-marks: false` to omit the two small fold
ticks from a finished letter.

Compile everything with:

```sh
sh tests/compile.sh
```

The template includes [`template/signature.svg`](template/signature.svg) as a
replaceable example asset. Perform a physical window-alignment test before
relying on a particular envelope or printer.

## References

- [Swiss Post: Addressing letters correctly](https://www.post.ch/en/sending-letters/addressing-and-designing/addressing-consignments-correctly)
- [Swiss Post: Designing and packaging letters](https://www.post.ch/en/sending-letters/addressing-and-designing)
- [Swiss Post: “Letter creation from A–Z” specification (PDF)](https://www.post.ch/-/media/portal-opp/pm/dokumente/briefe-spezifikation-gestaltung.pdf?hash=B86AC423E349F2084AECFE1957215836&sc_lang=en&vs=14)
