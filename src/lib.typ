// Swiss formal-letter layout for an A4 sheet folded into a C6/5 envelope.

#let swiss-c6-left = (
  paper: "a4",
  width: 21cm,
  height: 29.7cm,
  fold-guides: (10.5cm, 21cm),
  address: (
    x: 2cm,
    y: 4.5cm,
    width: 10cm,
    height: 4.5cm,
    inset-left: 2cm,
    inset-top: 1cm,
    inset-right: 1.2cm,
    return-height: 0.55cm,
  ),
  letterhead: (
    x: 12cm,
    y: 1.25cm,
    width: 7cm,
  ),
  body: (
    x: 2cm,
    y: 10.2cm,
    right: 2cm,
    bottom: 2cm,
  ),
)

#let clean-business-style = (
  font: "Liberation Sans",
  font-size: 10.5pt,
  line-height: 0.58em,
  accent: rgb("243d60"),
  muted: luma(42%),
  rule: luma(55%),
  address-font-size: 10pt,
  address-line-height: 0.25em,
  return-font-size: 6.5pt,
  return-rule: 0.45pt,
  letterhead-title-size: 14pt,
  letterhead-subtitle-size: 9pt,
  letterhead-detail-size: 7.5pt,
  letterhead-fill: white,
  letterhead-rule: 0.45pt,
  date-size: 8.7pt,
  subject-size: 10.5pt,
  signature-image-gap: 0.35cm,
  signature-name-gap: 0.15cm,
  signature-blank-space: 1.15cm,
  subject-weight: "bold",
  guide-blue: rgb("dceef8"),
)

#let _required-text(value, field) = {
  assert(type(value) == str, message: field + " must be a string")
  assert(value.match(regex("^\\s*$")) == none, message: field + " must not be empty")
  assert(
    value.match(regex("[\\r\\n]")) == none,
    message: field + " must contain exactly one line",
  )
  none
}

#let _optional-text(value, field) = {
  if value != none {
    _required-text(value, field)
  }
  none
}

// Structured data for a domestic Swiss recipient. The resulting postal block
// always has 3–6 non-empty lines and deliberately has no country field.
#let swiss-recipient(
  name: none,
  street: none,
  postcode: none,
  town: none,
  title: none,
  organization: none,
  department: none,
) = {
  _required-text(name, "name")
  _required-text(street, "street")
  _required-text(postcode, "postcode")
  _required-text(town, "town")
  _optional-text(title, "title")
  _optional-text(organization, "organization")
  _optional-text(department, "department")

  assert(
    postcode.match(regex("^\\d{4}$")) != none,
    message: "postcode must contain exactly four digits and must not use the CH- prefix",
  )

  let lines = ()
  if title != none { lines.push(title) }
  lines.push(name)
  if organization != none { lines.push(organization) }
  if department != none { lines.push(department) }
  lines.push(street)
  lines.push(postcode + " " + town)

  assert(lines.len() >= 3 and lines.len() <= 6, message: "recipient address must have 3–6 lines")
  (lines: lines,)
}

// Structured sender data. Optional contact details are rendered in the
// letterhead, never in the recipient window.
#let swiss-sender(
  name: none,
  street: none,
  postcode: none,
  town: none,
  role: none,
  organization: none,
  phone: none,
  email: none,
  website: none,
) = {
  _required-text(name, "sender name")
  _required-text(street, "sender street")
  _required-text(postcode, "sender postcode")
  _required-text(town, "sender town")
  _optional-text(role, "sender role")
  _optional-text(organization, "sender organization")
  _optional-text(phone, "sender phone")
  _optional-text(email, "sender email")
  _optional-text(website, "sender website")

  assert(
    postcode.match(regex("^\\d{4}$")) != none,
    message: "sender postcode must contain exactly four digits and must not use the CH- prefix",
  )

  let lines = ()
  lines.push(name)
  if role != none { lines.push(role) }
  if organization != none { lines.push(organization) }
  lines.push(street)
  lines.push(postcode + " " + town)
  if phone != none { lines.push(phone) }
  if email != none { lines.push(email) }
  if website != none { lines.push(website) }
  (
    lines: lines,
    name: name,
    role: role,
    organization: organization,
    street: street,
    postcode: postcode,
    town: town,
    phone: phone,
    email: email,
    website: website,
    return-line: name + " · " + street + " · " + postcode + " " + town,
  )
}

#let _line-stack(lines, size: 10pt, leading: 0.25em) = {
  set text(size: size)
  set par(leading: leading)
  for (index, line) in lines.enumerate() {
    line
    if index < lines.len() - 1 { linebreak() }
  }
}

#let _window-content(sender, recipient, layout, style) = {
  let width = layout.address.width - layout.address.inset-left - layout.address.inset-right
  box(
    width: width,
    height: layout.address.height - layout.address.inset-top,
    clip: true,
  )[
    #box(width: 100%, height: layout.address.return-height)[
      #set text(font: style.font, size: style.return-font-size, fill: style.muted)
      #sender.return-line
      #v(0.08cm)
      #line(length: 100%, stroke: style.return-rule + style.rule)
    ]
    #v(0.12cm)
    #set text(font: style.font, size: style.address-font-size, fill: black)
    #_line-stack(
      recipient.lines,
      size: style.address-font-size,
      leading: style.address-line-height,
    )
  ]
}

#let _letterhead(sender, layout, style) = {
  let subtitle = ()
  if sender.role != none { subtitle.push(sender.role) }
  if sender.organization != none { subtitle.push(sender.organization) }
  let contacts = ()
  if sender.phone != none {
    let phone-href = "tel:" + sender.phone.replace(regex("[^+0-9]"), "")
    contacts.push(link(phone-href)[#sender.phone])
  }
  if sender.email != none {
    contacts.push(link("mailto:" + sender.email)[#sender.email])
  }
  if sender.website != none {
    let website-href = if sender.website.starts-with("https://") or sender.website.starts-with("http://") {
      sender.website
    } else {
      "https://" + sender.website
    }
    contacts.push(link(website-href)[#sender.website])
  }
  let details = [
    #set text(size: style.letterhead-detail-size, fill: style.muted)
    #sender.street · #sender.postcode #sender.town
    #if contacts.len() > 0 {
      linebreak()
      contacts.join(linebreak())
    }
  ]

  block(
    width: layout.letterhead.width,
    inset: (top: 0.2cm),
    fill: style.letterhead-fill,
    stroke: (top: style.letterhead-rule + style.rule),
  )[
    #set text(font: style.font, fill: black)
    #align(right)[
      #text(size: style.letterhead-title-size, weight: "bold", sender.name)
      #if subtitle.len() > 0 {
        linebreak()
        move(dy: -0.26em)[
          #text(size: style.letterhead-subtitle-size, weight: "bold", fill: style.accent)[
            #subtitle.join([#h(1mm)#text(fill: style.muted)[|]#h(1mm)])
          ]
          #linebreak()
          #details
        ]
      } else {
        linebreak()
        details
      }
    ]
  ]
}

#let _positioned-first-page(sender, recipient, layout, style, debug: false, fold-marks: true) = context {
  if counter(page).get().first() == 1 {
    if debug {
      place(
        top + left,
        dx: layout.address.x,
        dy: layout.address.y,
        rect(
          width: layout.address.width,
          height: layout.address.height,
          fill: style.guide-blue,
          stroke: 0.6pt + black,
        ),
      )
    }

    if fold-marks {
      for y in layout.fold-guides {
        place(
          top + left,
          dx: 0cm,
          dy: y,
          line(length: 0.65cm, stroke: 0.45pt + style.rule),
        )
      }
    }

    place(
      top + left,
      dx: layout.letterhead.x,
      dy: layout.letterhead.y,
      _letterhead(sender, layout, style),
    )

    place(
      top + left,
      dx: layout.address.x + layout.address.inset-left,
      dy: layout.address.y + layout.address.inset-top,
      _window-content(sender, recipient, layout, style),
    )
  }
}

// Render a formal letter. Callers provide information and prose; the selected
// layout and style own all physical placement and presentation.
#let letter(
  sender: none,
  recipient: none,
  date: none,
  subject: none,
  salutation: none,
  closing: "Freundliche Grüsse",
  signature: none,
  signature-image: none,
  layout: swiss-c6-left,
  style: clean-business-style,
  debug: false,
  fold-marks: true,
  body,
) = {
  assert(type(sender) == dictionary and "lines" in sender, message: "sender must be created with swiss-sender")
  assert(type(recipient) == dictionary and "lines" in recipient, message: "recipient must be created with swiss-recipient")
  assert(recipient.lines.len() >= 3 and recipient.lines.len() <= 6, message: "recipient address must have 3–6 lines")

  set page(
    paper: layout.paper,
    margin: (
      left: layout.body.x,
      right: layout.body.right,
      top: layout.body.y,
      bottom: layout.body.bottom,
    ),
    background: _positioned-first-page(
      sender,
      recipient,
      layout,
      style,
      debug: debug,
      fold-marks: fold-marks,
    ),
  )
  set text(font: style.font, size: style.font-size, fill: black)
  set par(justify: false, leading: style.line-height)
  show link: set text(fill: black)

  align(right, text(size: style.date-size, fill: style.muted, date))
  v(0.7cm)
  text(
    size: style.subject-size,
    weight: style.subject-weight,
    fill: style.accent,
    subject,
  )
  v(0.75cm)
  salutation
  v(0.55cm)
  body
  v(0.85cm)
  closing
  if signature-image != none {
    v(style.signature-image-gap)
    signature-image
  }
  if signature != none {
    if signature-image != none {
      v(style.signature-name-gap)
    } else {
      v(style.signature-blank-space)
    }
    signature
  }
}
