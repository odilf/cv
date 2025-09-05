#import "@preview/libra:0.1.0": balance

#let lang = sys.inputs.at("lang", default: "es")
#let data = yaml("data.yaml").at(lang)
#let alt(en, es) = if lang == "en" { en } else { es }

#assert(lang == "es" or lang == "en", message: "Supported languages are Spanish and English.")

#set page(
  paper: "a4",
  fill: rgb("#f4f1eb"),
  margin: 1.25cm
)

#set text(font: "Lora", lang: lang, size: 10pt)

#set list(marker: ([*›*]))

#show link: body => underline(text(fill: blue.darken(50%), body))
#show heading.where(
  level: 1
): it => {
  box(text(
    size: 1em + 4pt,
    weight: 600,
    style: "italic",
    it.body,
  ))
}

#let faint(body) = text(fill: black.transparentize(40%), body)
#let split(main, supplement) = box(grid(
  columns: (1fr, auto),
  gutter: 1mm,
  main,
  supplement
))
#let icon(name) = box(image("img/icons/" + lower(name) + ".svg", height: 1em), baseline: 15%)

#grid(
  columns: (1fr, 0.45fr),
  gutter: 14pt,
  [
    #[ 
      #text(size: 40pt, tracking: -0.8mm)[#text(weight: 400)[Odysseas Machairas]]
      #v(16pt, weak: true)
      #text(size: 20pt, tracking: -0.17mm, balance(data.summary))
      #v(12pt, weak: true)
    ]

    #split[
      #align(bottom)[
        = #icon("graduation-cap") #alt[Education][Educación]
      ]
    ][
      #align(right, faint[
        #for (type, value) in data.contact.pairs() [
          #icon(type) #link(value) \
        ]
      ])

      #v(2mm)
    ]

    #set list(marker: ([*$tack.r$*], [*›*]))

    
    #list(tight: false, spacing: 11pt, ..data.education.map(entry => {
      [
        #split[*#text(size: 1em + 2pt, entry.degree)*][*#faint(entry.date)*]
        #faint[#emph(entry.institution), #entry.location] \
        #if "grade" in entry [
          #entry.grade.chunks(2).map(((gtext, grade)) => [#gtext: *#text(size: 1em + 2pt, grade)*]).join("\n")
        ] 
        #set text(size: 1em - 0.3pt)
        #if "major" in entry [  
          - #eval(entry.major, mode: "markup")
          - #eval(entry.minor, mode: "markup")
        ]
        #if "thesis" in entry [
          - #alt[Thesis][Tesis]: #link("https://github.com/odilf/bachelor-thesis/releases/download/2025-06-25/paper.pdf")[*#entry.thesis*]
        ]
      ]
    }))

    = #icon("trophy") #alt[Awards and recognition][Premios y reconocimiento]
    
    #list(tight: true, spacing: 10pt, ..data.awards.map(entry => {
      [
        #split[*#text(size: 1em + 2pt, entry.title)*][*#faint(entry.date)*]
        #box(balance(eval(entry.desc, mode: "markup")))
      ]
    }))

    = #icon("briefcase-business") #alt[Experience][Experiencia]

    #list(tight: true, spacing: 16pt, ..data.experience.map(entry => {
      [
        #split[*#text(size: 1em + 2pt, eval(entry.title, mode: "markup"))*][*#faint(entry.date)*]
        #if "institution" in entry [#faint[#entry.institution]] \
        #box(balance(entry.desc)) 
        #list(..entry.roles.map(role => {
          if type(role) == str {
            eval(role, mode: "markup")
          } else {
            [#link(role.link, role.title)#if "desc" in role [: #role.desc]]
          }
        }))
      ]
    }))
  ],
  [
    #box(clip: true, radius: 0.5cm,
      width: 100%, height: 6.4cm,
      image("./img/passport.jpeg", width: 100%)
    )

    = #icon("cog") #alt[Skills][Habilidades]

    == #alt[Programming languages][Lenguajes de programación]
    #for (pl, proficiency) in data.skills.programming-languages.pairs() [
      #icon(pl) *#pl* #h(1fr) #proficiency \
    ]

    = #icon("languages") #alt[Languages][Idiomas]

    #for (lang, proficiency) in data.languages.pairs() [
      - *#lang* #h(1fr) #proficiency
    ]

    = #icon("brain") #alt[Personality][Personalidad]

    #for item in data.personality [
      - #item
    ]
  ],
)



