#!/bin/bash

echo "Daily Standup - $(date '+%Y-%m-%d')"
echo "================================"
echo ""

echo "Getting status..."
echo ""
echo ""

echo "Today's activity (files touched in last day):"
echo "=============================================="
echo ""

recent_files=$(find prds epics -name "*.md" -mtime -1 2>/dev/null)

if [ -n "$recent_files" ]; then
  prd_count=$(echo "$recent_files" | grep -c "/prds/" 2>/dev/null | tr -d '[:space:]')
  epic_count=$(echo "$recent_files" | grep -c "/epic.md" 2>/dev/null | tr -d '[:space:]')
  task_count=$(echo "$recent_files" | grep -c "/T[0-9][0-9][0-9].md" 2>/dev/null | tr -d '[:space:]')
  prd_count=${prd_count:-0}
  epic_count=${epic_count:-0}
  task_count=${task_count:-0}

  [ "$prd_count" -gt 0 ] && echo "  - Modified $prd_count PRD(s)"
  [ "$epic_count" -gt 0 ] && echo "  - Updated $epic_count epic(s)"
  [ "$task_count" -gt 0 ] && echo "  - Updated $task_count work item file(s)"
else
  echo "  No markdown activity recorded in the last day"
fi

echo ""
echo "Marked in progress (status: in-progress):"
found_ip=0
for epic_dir in epics/*/; do
  [ -d "$epic_dir" ] || continue
  case "$epic_dir" in
    */archived/*) continue ;;
  esac
  for task_file in "$epic_dir"/T*.md; do
    [ -f "$task_file" ] || continue
    status=$(grep "^status:" "$task_file" | head -1 | sed 's/^status: *//;s/[[:space:]]*$//')
    [ "$status" = "in-progress" ] || continue
    task_id=$(basename "$task_file" .md)
    epic_name=$(basename "$epic_dir")
    task_name=$(grep "^name:" "$task_file" | head -1 | sed 's/^name: *//')
    echo "  - $task_id ($epic_name) - $task_name"
    found_ip=$((found_ip + 1))
  done
done
[ "$found_ip" -eq 0 ] && echo "  (none)"

echo ""
echo "Next available work items (open, no dependencies):"
count=0
for epic_dir in epics/*/; do
  [ -d "$epic_dir" ] || continue
  case "$epic_dir" in
    */archived/*) continue ;;
  esac
  for task_file in "$epic_dir"/T*.md; do
    [ -f "$task_file" ] || continue
    status=$(grep "^status:" "$task_file" | head -1 | sed 's/^status: *//')
    [ "$status" = "open" ] || continue

    deps_line=$(grep "^depends_on:" "$task_file" | head -1)
    deps=$(echo "$deps_line" | sed 's/^depends_on: *//' | sed 's/^\[//' | sed 's/\]$//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    [ -z "$deps" ] || continue

    task_name=$(grep "^name:" "$task_file" | head -1 | sed 's/^name: *//')
    task_id=$(basename "$task_file" .md)
    echo "  - $task_id - $task_name"
    count=$((count + 1))
    [ "$count" -ge 5 ] && break 2
  done
done

echo ""
echo "Quick stats:"
total_tasks=$(find epics -path "*/archived/*" -prune -o -name "T*.md" -type f -print 2>/dev/null | wc -l)
open_tasks=$(find epics -path "*/archived/*" -prune -o -name "T*.md" -type f -print 2>/dev/null | xargs grep -l "^status: *open" 2>/dev/null | wc -l)
closed_tasks=$(find epics -path "*/archived/*" -prune -o -name "T*.md" -type f -print 2>/dev/null | xargs grep -l "^status: *closed" 2>/dev/null | wc -l)
echo "  Work items: ${open_tasks:-0} open, ${closed_tasks:-0} closed, ${total_tasks:-0} total"

exit 0
