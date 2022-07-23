# Data schema

Backus Naur Form (BNF) for the Mikrokosmos Ontology

Notation:
- { } are used for grouping;
- [ ] means optional (i.e., 0 or 1);
- \+ means 1 or more;
- \* means 0 or more.

### Ontology

```
<ontology> :=
  <concept>+

<onomasticon> :=
  <instance>+

<concept> :=
  <root> | <object-or-event> | <property>

<root> :=
  EVERYTHING
  <def-slot>
  <time-stamp-slot>
  <subclasses-slot>

;; EVERYTHING is the name of the root concept

<object-or-event> :=
  <concept-name>
  <def-slot>
  <time-stamp-slot>
  <isa-slot>
  [<subclasses-slot>]
  [<instances-slot>]
  <other-slot>*

<instance> :=
  <instance-name>
  <def-slot>
  <time-stamp-slot>
  <instance-of-slot>
  <instance-other-slot>*

PROPERTY :=
  RELATION | ATTRIBUTE | ONTOLOGY-SLOT

RELATION :=
  <relation-name>
  <def-slot>
  <time-stamp-slot>
  <isa-slot>
  [<subclasses-slot>]
  <domain-slot>
  <rel-range-slot>
  <inverse-slot>

<attribute> :=
  <attribute-name>
  <def-slot>
  <time-stamp-slot>
  <isa-slot>
  [<subclasses-slot>]
  <domain-slot>
  [<attr-range-slot>]

ONTOLOGY-SLOT ::= ONTOLOGY-SLOT-NAME DEF-SLOT TIME-STAMP-SLOT
  ISA-SLOT [SUBCLASSES-SLOT] DOMAIN-SLOT ONTO-RANGE-SLOT
  INVERSE-SLOT

<concept-name> := <name-string>

<instance-name> := <name-string>

<relation-name> := <name-string>

<attribute-name> := <name-string>

<name-string> :=
  <alpha> {<alpha> | <digit>}* {- {<alpha> | <digit>}+ }*

;; Note: The same <name-string> cannot be more than one of a
;; <concept-name>, an <instance-name>, a <relation-name>, and an
;; <attribute-name>.

<def-slot> :=
  DEFINITION Value <an English definition string>

<time-stamp-slot> :=
  TIME-STAMP Value <time-date-and-username>+

<isa-slot> :=
IS-A Value { ALL | <concept-name>+ | <relation-name>+ | <attribute-name>+ }

<subclasses-slot> :=
  SUBCLASSES Value { <concept-name>+ | <relation-name>+ | <attribute-name>+ }

<instances-slot> :=
  INSTANCES Value <instance-name>+

<instance-of-slot> :=
  INSTANCE-OF Value <concept-name>+

<other-slot> := (DEPRECATED?)
  <relation-slot> | <attribute-slot>

<relation-slot> :=
 <relation-name> <facet> <concept-name>+

<attribute-slot> :=
  <attribute-name> <facet> { <number> | <literal> }+

<facet> :=
  value | sem | default | relaxable-to | not | default-measure | inv | time-range | info-source

<instance-other-slot> :=
  <instance-relation-slot> | <instance-attribute-slot>

<instance-relation-slot> :=
  <relation-name> Value <instance-name>+

<instance-attribute-slot> :=
  <attribute-name> Value { <number> | <literal> }+

<domain-slot> :=
  DOMAIN Sem <concept-name>+

<rel-range-slot> :=
  RANGE Sem <concept-name>+

<attr-range-slot> :=
  RANGE Sem { <number> | <literal> }*

<inverse-slot> :=
  INVERSE Value <relation-name>

<alpha> :=
  A | B | C | ... | Y | Z

;; <number> and <literal> have not been expanded here but have obvious
;; definitions: a number is any string of digits with a possible
;; decimal point and a possible +/- sign; a literal is any alphanumeric
;; string starting with an <alpha>.
```

### Text Meaning Representation (TMR)
```
TMR ::=
  PROPOSITION+
  DISCOURSE-RELATION*
  MODALITY*
  STYLE
  REFERENCE*
  TMR-TIME

PROPOSITION ::=
proposition
  head: concept-instance
  ASPECT
  PROPOSITION-TIME
  STYLE

ASPECT ::=
aspect
  aspect-scope: concept-instance
  phase: begin | continue | end | begin-continue-end
  iteration: integer | multiple

TMR-TIME ::= set
  element-type  proposition-time
  cardinality  >= 1

PROPOSITION-TIME ::=
time
  time-begin: TIME-EXPR*
  time-end:  TIME-EXPR*

TIME-EXPR ::= << | < | > | >> | >= | <= | = | != {ABSOLUTE-TIME | RELATIVE-TIME}

ABSOLUTE-TIME ::= {+/-}TTTTMMDDHHMMSSFFFF [ [+/-] real-number temporal-unit ]

RELATIVE-TIME ::= CONCEPT-INSTANCE.TIME [ [+/-] real-number temporal-unit]

STYLE ::=
style
  formality: (0,1)
  politeness:  (0,1)
  respect: (0,1)
  force: (0,1)
  simplicity: (0,1)
  color: (0,1)
  directness: (0,1)

DISCOURSE-RELATION ::=
  relation-type: ontosubtree (discourse-relation)
  domain: proposition+
  range: proposition+

MODALITY ::=
modality
  modality-type: MODALITY-TYPE
  modality-value: (0,1)
  modality-scope: concept-instance*
  modality-attributed-to: concept-instance*

MODALITY-TYPE ::= epistemic | deontic | volitive | potential | epiteutic | evaluative | saliency

REFERENCE ::= SET
  element-type (coreference concept-instance concept-instance+)
  cardinality > 1

SET ::=
set
  element-type: concept | concept-instance
  cardinality: [ < | > | >= | <= | <> ] integer
  complete: boolean
  excluding: [ concept | concept-instance ]*
  elements: concept-instance*
  subset-of: SET

```

### Lexicon

```
SUPERENTRY ::=
  ORTHOGRAPHIC-FORM: "FORM"
  ({SYN-CAT}: <LEXEME>)

LEXEME ::=
  CATEGORY: {SYN-CAT}
  ORTHOGRAPHY:
    VARIANTS: "BARIANTS"*
    ABBREVIATIONS: "ABBS"*
    PHONOLOGY: "PHONOLOGY"*
    MORPHOLOGY:
      IRREGULAR-FORMS: ("FORM" {IRREG-FORM-NAME})*
      PARADIGM: {PARADIGM-NAME}
      STEM-VARIANTS: ("FORM" {VARIANT-NAME})*
    ANOTATIONS:
      DEFINITION: "DEFINITION IN NL"*
      EXAMPLES: "EXAMPLE"*
      COMMENTS: "LEXICOGRAPHER COMMENT"*
      TIME-STAMP: {LEXICOG-ID DATE-OF-ENTRY}*
    SYNTACTIC-FEATURES: (FEATURE VALUE)*
    SYNTACTIC-STRUCTURE: F-STRUCTURE
    SEMANTIC-STRUCTURE: LEX-SEM-SPECIFICATION
```

