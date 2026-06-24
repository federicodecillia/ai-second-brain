---
type: dashboard
tags: [dashboard, tasks, meta]
---

## For future agents
**A view, not a container.** This page holds no tasks of its own: the Obsidian **Tasks** plugin aggregates every `- [ ]` task across the vault (hub, routines, project/area files) with its emoji metadata and shows them here. To write a task, go to the right input file (a project/area file, loose -> [[hub]], recurring -> [[routines]]) and it appears here on its own. Deleting this page loses nothing; deleting an input file does. ([[hub]] is one of many inputs; this is the view that sums them.) Tasks inside `00_Inbox/` are excluded — raw captures aren't real tasks yet; they show up once the weekly maintenance files them. Requires the Tasks plugin.

> [!info] Emoji convention: `📅` due · `⏫`/`🔺` high priority · `🔽` low · `🔁` recurring · `✅` done

## 🔴 Overdue
```tasks
not done
path does not include 00_Inbox
due before today
sort by due
```

## 📅 Today and next 7 days
```tasks
not done
path does not include 00_Inbox
due before in 8 days
due after yesterday
sort by due
sort by priority
```

## ⏫ Prioritized, no due date
```tasks
not done
path does not include 00_Inbox
no due date
(priority is above none)
sort by priority
```

## 🗂 All open tasks (with a due date or priority), grouped by file
```tasks
not done
(has due date) OR (priority is above none)
path does not include 00_Inbox
group by filename
sort by due
```

## ✅ Recently completed (last 14 days)
```tasks
done
done after 14 days ago
sort by done reverse
```
