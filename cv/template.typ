// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): block.with(
    fill: luma(230), 
    width: 100%, 
    inset: 8pt, 
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    new_title_block +
    old_callout.body.children.at(1))
}

#show ref: it => locate(loc => {
  let target = query(it.target, loc).first()
  if it.at("supplement", default: none) == none {
    it
    return
  }

  let sup = it.supplement.text.matches(regex("^45127368-afa1-446a-820f-fc64c546b2c5%(.*)")).at(0, default: none)
  if sup != none {
    let parent_id = sup.captures.first()
    let parent_figure = query(label(parent_id), loc).first()
    let parent_location = parent_figure.location()

    let counters = numbering(
      parent_figure.at("numbering"), 
      ..parent_figure.at("counter").at(parent_location))
      
    let subcounter = numbering(
      target.at("numbering"),
      ..target.at("counter").at(target.location()))
    
    // NOTE there's a nonbreaking space in the block below
    link(target.location(), [#parent_figure.at("supplement") #counters#subcounter])
  } else {
    it
  }
})

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      block(
        inset: 1pt, 
        width: 100%, 
        block(fill: white, width: 100%, inset: 8pt, body)))
}

// const color
#let color_darknight = rgb("#131A28")
#let color_darkgray = rgb("333333")

// layout utility
#let justify_align(left_body, right_body) = {
  block[
    #left_body
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let justify_align_3(left_body, mid_body, right_body) = {
  block[
    #box(width: 1fr)[
      #align(left)[
        #left_body
      ]
    ]
    #box(width: 1fr)[
      #align(center)[
        #mid_body
      ]
    ]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let resume(author: (), date: "", body) = {
  
  set document(
    author: author.firstname + " " + author.lastname, 
    title: "resume",
  )
  
  set text(
    font: ("New Computer Modern"),
    lang: "en",
    size: 11pt,
    fill: color_darknight,
    fallback: false
  )

  set page(
    paper: "a4",
    margin: (left: 15mm, right: 15mm, top: 10mm, bottom: 10mm),
    footer: [
      #set text(fill: gray, size: 8pt)
      #justify_align_3[
        #smallcaps[#date]
      ][
        #smallcaps[
          #author.firstname
          #author.lastname
          #sym.dot.c
          #"Résumé"
        ]
      ][
        #counter(page).display()
      ]
    ],
    footer-descent: 0pt,
  )
  
  // set paragraph spacing
  show par: set block(above: 0.75em, below: 0.75em)
  set par(justify: true)

  set heading(
    numbering: none,
    outlined: false,
  )
  
  let name = {
    align(center)[
      #pad(bottom: 5pt)[
        #block[
          #set text(size: 32pt, style: "normal", font: ("Roboto"))
          #text(weight: "thin")[#author.firstname]
          #text(weight: "bold")[#author.lastname]
        ]
      ]
    ]
  }

  let positions = {
    set text(
      size: 9pt,
      weight: "regular"
    )
    align(center)[
      #smallcaps[
        #author.positions.join(
          text[#"  "#sym.dot.c#"  "]
        )
      ]
    ]
  }

  let contacts = {
    set box(height: 11pt)
    
    let linkedin_icon = box(image("_extensions/cv/assets/icons/linkedin.svg"))
    let github_icon = box(image("_extensions/cv/assets/icons/square-github.svg"))
    let email_icon = box(image("_extensions/cv/assets/icons/square-envelope-solid.svg"))
    let phone_icon = box(image("_extensions/cv/assets/icons/square-phone-solid.svg"))
    let separator = box(width: 5pt)
    
    align(center)[
      #block[
        #align(horizon)[
          #phone_icon
          #box[#text(author.phone)]
          #separator
          #email_icon
          #box[#link("mailto:" + author.email)[#author.email]]
          #separator
          #github_icon
          #box[#link("https://github.com/" + author.github)[#author.github]]
          #separator
          #linkedin_icon
          #box[
            #link("https://www.linkedin.com/in/" + author.linkedin)[#author.linkedin]
          ]
        ]
      ]
    ] 
  }

  name
  positions
  contacts
  body
}

// general style
#let resume_section(title) = {
  set text(
    size: 16pt,
    weight: "regular"
  )
  align(left)[
    #smallcaps[
      // #text[#title.slice(0, 3)]#strong[#text[#title.slice(3)]]
      #strong[#text[#title]]
    ]
    #box(width: 1fr, line(length: 100%))
  ]
}

#let resume_item(body) = {
  set text(size: 10pt, style: "normal", weight: "light")
  set par(leading: 0.65em)
  body
}

#let resume_time(body) = {
  set text(weight: "light", style: "italic", size: 9pt)
  body
}

#let resume_degree(body) = {
  set text(size: 10pt, weight: "light")
  smallcaps[#body]
}

#let resume_organization(body) = {
  set text(size: 12pt, style: "normal", weight: "bold")
  body
}

#let resume_location(body) = {
  set text(size: 12pt, style: "italic", weight: "light")
  body
}

#let resume_position(body) = {
  set text(size: 10pt, weight: "regular")
  smallcaps[#body]
}

#let resume_category(body) = {
  set text(size: 11pt, weight: "bold")
  body
}

#let resume_gpa(numerator, denominator) = {
  set text(size: 12pt, style: "italic", weight: "light")
  text[Cumulative GPA: #box[#strong[#numerator] / #denominator]]
}

// sections specific components
#let education_item(organization, degree, gpa, time_frame) = {
  set block(above: 0.7em, below: 0.7em)
  set pad(top: 5pt)
  pad[
    #justify_align[
      #resume_organization[#organization]
    ][
      #gpa
    ]
    #justify_align[
      #resume_degree[#degree]
    ][
      #resume_time[#time_frame]
    ]
  ]
}

#let work_experience_item_header(
  company,
  location,
  position,
  time_frame
) = {
  set block(above: 0.7em, below: 0.7em)
  set pad(top: 5pt)
  pad[
    #justify_align[
      #resume_organization[#company]
    ][
      #resume_location[#location]
    ]
    #justify_align[
      #resume_position[#position]
    ][
      #resume_time[#time_frame]
    ]
  ]
}

#let personal_project_item_header(
  name,
  location,
  position,
  start_time,
) = {
  set block(above: 0.7em, below: 0.7em)
  set pad(top: 5pt)
  pad[
    #justify_align[
      #resume_organization[#name]
    ][
      #resume_location[#location]
    ]
    #justify_align[
      #resume_position[#position]
    ][
      #resume_time[#start_time]
    ]
  ]
}

#let skill_item(category, items) = {
  set block(above: 1.0em, below: 1.0em)
  
  grid(
    columns: (18fr, 80fr),
    gutter: 10pt,
    align(right)[
      #resume_category[#category]
    ],
    align(left)[
      #set text(size: 11pt, style: "normal", weight: "light")
      #items.join(", ")
    ],
  )
}

#show: resume.with(
  author: (
      firstname: "Aaaaaaa", 
      lastname: "Aaa",
      email: "aaaaaaaaaa\@aaaaa.aaa",
      phone: "\(+1) 0000000000",
      github: "aaaaaaaaa",
      linkedin: "aaaaaaaa",
      positions: (
                  ("Aaaaaaaa Aaaaaaaa"),
                  ("Aaaa Aaaaa Aaaaaaaaa"),
              )
  ),
  //TODO: Fix date with current date https://github.com/typst/typst/issues/204
    date: "Invalid Date",
)


#show heading.where(level: 1): it => [
  #resume_section(it.body)
]







// #let education_element = query(
//   selector(list)
// )


// #resume_section("Education")

// #education_item[
//   University of Aaaaaaaa Aaaaaaa-Aaaaaaaaa
// ][
//   Master of Computer Science
// ][
//   #resume_gpa("4.00", "4.00")
// ][
//   Aug. 0000 - Aug. 0000
// ]

// #education_item[
//   University of Aaaaaaaa-Aaaaaaa
// ][
//   B.S. in Computer Science
// ][
//   #resume_gpa("4.00", "4.00")
// ][
//   Aug. 0000 - Aug. 0000
// ]

// #resume_section("Experience")

// #work_experience_item_header(
//   "Aaaaaa Aaaaaaaa",
//   "Aaaaaa Aaaaa Aaaaa, AA",
//   "Software Engineer",
//   "Jul. 0000 - Jul. 0000",
// )

// #resume_item[
//   - *#lorem(10)*. #lorem(20)
//   - #lorem(30)
//   - #lorem(40)
//   - #lorem(30)
// ]

// #work_experience_item_header(
//   "Aaaaaa Aaaaaaaa",
//   "Aaaaaa Aaaaa Aaaaa, AA",
//   "Software Engineer",
//   "Jul. 0000 - Jul. 0000",
// )

// #resume_item[
//   - *#lorem(10)*. #lorem(20)
//   - #lorem(30)
//   - #lorem(40)
//   - #lorem(30)
// ]

// #resume_section("Personal Project")

// #personal_project_item_header(
//   "Aaaaaaa Aaaa",
//   "Aaaaaa, AA",
//   "AAAAAAA",
//   "Feb. 0000",
// )

// #resume_item[
//   - #lorem(30)
// ]

// #personal_project_item_header(
//   "Aaaaaaa Aaaa",
//   "Aaaaaa, AA",
//   "AAAAAAA",
//   "Feb. 0000",
// )

// #resume_item[
//   - #lorem(30)
// ]

// #resume_section("Skills")

// #skill_item(
//   "Program Language",
//   (
//     strong[Aaaaa],
//     strong[Aaaaaa], 
//     strong[Aaaa], 
//     strong[Aaaaaa], 
//     strong[Aaaaaaa], 
//     strong[Aaaa],
//     "A/A++",
//     "Aaaa", 
//     "Aaaaaaa", 
//     "Aaaa", 
//     "Aaaaa",
//     "A/A++",
//     "Aaaa", 
//     "Aaaaaaa", 
//     "Aaaa", 
//     "Aaaaa"
//   )
// )

// #skill_item(
//   "Back-End",
//   (
//     strong[Aaaaa],
//     strong[Aaaaaa], 
//     strong[Aaaa], 
//     "Aaaaaa", 
//     "Aaaaaaa", 
//     "Aaaa",
//     "A/A++",
//     "Aaaa", 
//     "Aaaaaaa", 
//   )
// )

// #skill_item(
//   "Front-End",
//   (
//     strong[Aaaaa],
//     strong[Aaaaaa], 
//     strong[Aaaa], 
//     strong[Aaaaaa], 
//     strong[Aaaaaaa], 
//     "Aaaa",
//     "A/A++",
//     "Aaaa", 
//     "Aaaaaaa", 
//   )
// )

// #skill_item(
//   "DevOps",
//   (
//     strong[Aaaaa],
//     strong[Aaaaaa], 
//     strong[Aaaa], 
//     strong[Aaaaaa], 
//     strong[Aaaaaaa], 
//     strong[Aaaa],
//     "A/A++",
//     "Aaaa", 
//     "Aaaaaaa", 
//     "Aaaaaaa", 
//   )
// )


= Education
<education>
== University of Aaaaaaaa Aaaaaaa-Aaaaaaaaa
<university-of-aaaaaaaa-aaaaaaa-aaaaaaaaa>
- Master of Computer Science
- "4.00", "4.00"
- Aug.~0000 - Aug.~0000

== University of Aaaaaaaa-Aaaaaaa
<university-of-aaaaaaaa-aaaaaaa>
- B.S. in Computer Science
- "4.00", "4.00"
- Aug.~0000 - Aug.~0000

= Experience
<experience>
= Personal Project
<personal-project>
= Skills
<skills>



