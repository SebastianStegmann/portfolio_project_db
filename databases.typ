#import "@preview/modern-iu-thesis:0.1.2": *

#let title = [SUBPROJECT 1: DATABASE];

#let date = [30 September 2025];

#let names = [SOFIE WINDELØV\ NIKOLAJ KRING\ SEBASTIAN STEGMANN];

#set page(header: context {
  if counter(page).get().first() > 1 [
    Subproject 1: Database
    #h(1fr)
    Roskilde University
  ]
}

)



#set text(weight: 700);
#align(center)[
  #v(140pt)
  #set text(18pt)
  #title
  #v(150pt)
  #set text(12pt)
  by \
  \ 
  #names

  #v(200pt)
  Roskilde University \
  Computer Science Msc \
  \
  #date

];

#set text(weight: 400);


#align(center)[]

#pagebreak();

#outline()

#set heading(numbering: "1.A.1")

#set page(numbering: "1");
#counter(page).update(1)

= Introduction

#lorem(100)

== Application Design

==  The Movie Data Model

=== Data Model
=== Implementation


==  Framework Model

=== Data Model
=== Implementation


==  Functionality

=== Basic Framework Functionality
=== Simple Search
=== Title Rating
=== Structured String Search
=== Finding Names
=== Finding Co-players
=== Name Rating
=== Popular actors
=== Similar Movies
=== Frequent Person Words
=== Exact-match Querying
=== Best-match Querying
==  Word-to-words Querying

== Improving performance by indexing

== Testing using the IMDB database
