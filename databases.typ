#import "@preview/modern-iu-thesis:0.1.2": *

#let title = [Subproject 1: Database];

#let date = [30 September 2025];

#let names = [Sofie Windeløv\ Nikolaj Kring\ Sebastian Stegmann];

#set page(header: context {
  if counter(page).get().first() > 1 [
    _Lisa Strassner's Thesis_
    #h(1fr)
    National Academy of Sciences
  ]
}

)

#set page(numbering: "(i)");
#counter(page).update(1);
#set page(numbering: "1");

#align(center)[
  #title
  #names

  #date
];


#align(center)[]

#pagebreak();

= Introduction

#lorem(100)

== History

#lorem(100)

#align(center)[
  #figure(emoji.explosion, caption: [Kapow!])
]

#lorem(200)

#iuquote([#lorem(50)])

=== More History

$ delta S & = delta integral cal(L) dif t = 0 $

#align(center)[
  #figure(
    table(
      columns: 3,
      table.header([], [*Thing 1*], [*Thing 2*]),
      [Experiment 1], [1.0], [2.0],
      [Experiment 2], [3.0], [4.0],
    ),
    caption: [My table],
  )
]

