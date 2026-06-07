---
date: 2026-01-01
type: project
status: active
tags: [project, example]
---

# Example Project

> This is a sample project so you can see the convention. **Delete this folder** (or
> rename and rewrite it) once you create your first real project. Each project lives in
> its own folder under `01_Projects/` and holds a MOC note (this file, named like the
> folder) plus a `tasks.md`. A project is an initiative **with an end** — when it ships,
> archive the folder into `09_Archive/`.

## Overview
One or two lines on what this project is and the outcome that means "done".

## Key decisions
- (date) — decisions you make along the way, append-only.

## Links
- Related area: `[[example-area]]` (link the area this project serves)
- People involved, source docs, references.

## Recent activity
```dataview
LIST FROM "Daily"
WHERE contains(file.outlinks, this.file.link)
SORT date DESC
LIMIT 5
```
