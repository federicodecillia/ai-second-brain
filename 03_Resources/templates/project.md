---
date: {{date}}
type: project
status: active
tags: [project]
---

# {{title}}

## Overview

## Key decisions

## Links

## Recent activity
```dataview
LIST FROM "Daily"
WHERE contains(file.outlinks, this.file.link)
SORT date DESC
LIMIT 5
```
