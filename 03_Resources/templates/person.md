---
type: person
tags: [person]
role:
company:
relationship:
last_interaction: {{date}}
contact:
---

# {{title}}

## About

## What they care about

## How we can help each other

## Links
- Area/project:

## Interactions
```dataview
LIST FROM "Daily"
WHERE contains(file.outlinks, this.file.link)
SORT date DESC
LIMIT 15
```
