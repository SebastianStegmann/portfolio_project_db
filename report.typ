#import "@preview/pintorita:0.1.4"

= Database
== Portfolio project part 1
=== Group 4
==== Sofie (stud-swindeloev)
==== Nikolaj (stud-nkring)
==== Sebastian (stud-sstegmann)


= 1-A
= 1-B
= 1-C
= 1-D



#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

```pintora

erDiagram

@param layoutDirection TB
  title: Entity Relationship Example
  CUSTOMER {
    int id PK
    int address FK
  }
  CUSTOMER ||--o{ ORDER : places
  ORDERS ||--|{ LINE-ITEM : contains
  CUSTOMER }|..|{ DELIVERY-ADDRESS : uses
  ORDERS {
    int orderNumber PK
    int customer FK "customer id"
    string deliveryAddress
  }
  
  GENRE {
    int genreid PK
    string genre_name
  }
```
