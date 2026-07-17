// ATS-friendly single-column resume.
// Content comes from data.json — edit that file, not this template.
// Build: typst compile ats.typ Ahmad_Syamim_Resume_ATS.pdf

#let data = json("data.json")

#set page(paper: "a4", margin: (x: 2cm, y: 1.8cm))
#set text(font: "Libertinus Serif", size: 10.5pt, ligatures: false, lang: "en")
#set par(justify: false, leading: 0.6em)

#let sectionHeader(title) = {
  v(0.9em)
  text(size: 11.5pt, weight: "bold")[#title]
  v(-0.5em)
  line(length: 100%, stroke: 0.5pt)
  v(0.1em)
}

#let bullet(body) = {
  pad(left: 1em)[- #body]
}

// HEADER
#align(center)[
  #text(size: 18pt, weight: "bold")[#data.profile.name]

  #data.profile.title

  #data.profile.location | #data.profile.phone | #data.profile.email

  #data.profile.github | #data.profile.linkedin
]

// SUMMARY
#sectionHeader("SUMMARY")
#data.profile.summary

// SKILLS
#sectionHeader("SKILLS")
#for group in data.skills [
  #text(weight: "bold")[#group.group:] #group.items.join(", ")

]

// EXPERIENCE
#sectionHeader("EXPERIENCE")
#for job in data.experience [
  #text(weight: "bold")[#job.role] \
  #job.company, #job.location \
  #job.dates
  #for b in job.bullets [
    #bullet(b)
  ]
  #v(0.5em)
]

// PROJECTS
#sectionHeader("PROJECTS")
#for p in data.projects [
  #text(weight: "bold")[#p.name] (#p.status) \
  Technologies: #p.stack.join(", ")
  #bullet(p.description)
  #if p.github_url != none [
    #bullet[GitHub: #p.github_url]
  ]
  #if p.demo_url != none [
    #bullet[Live demo: #p.demo_url]
  ]
  #if p.private_repo [
    #bullet[Private repository]
  ]
  #v(0.5em)
]

// EDUCATION
#sectionHeader("EDUCATION")
#for e in data.education [
  #text(weight: "bold")[#e.institution] \
  #e.degree, #e.location#if e.gpa != none [, CGPA #e.gpa] \
  #e.dates
  #for n in e.notes [
    #bullet(n)
  ]
  #v(0.5em)
]

// LANGUAGES
#sectionHeader("LANGUAGES")
#for l in data.languages [
  #bullet[#l.name (#l.level)]
]
