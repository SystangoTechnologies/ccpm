#!/bin/bash
echo "Getting status..."
echo ""
echo ""

echo "In progress (from task files)"
echo "=============================="
echo ""

found=0

if [ -d "epics" ]; then
  for epic_dir in epics/*/; do
    [ -d "$epic_dir" ] || continue
    case "$epic_dir" in
      */archived/*) continue ;;
    esac
    for task_file in "$epic_dir"/T*.md; do
      [ -f "$task_file" ] || continue
      status=$(grep "^status:" "$task_file" | head -1 | sed 's/^status: *//;s/[[:space:]]*$//')
      [ "$status" = "in-progress" ] || continue

      epic_name=$(basename "$epic_dir")
      task_id=$(basename "$task_file" .md)
      task_name=$(grep "^name:" "$task_file" | head -1 | sed 's/^name: *//')
      jira_key=$(grep "^jira_key:" "$task_file" | head -1 | sed 's/^jira_key: *//')

      echo "Task $task_id - $task_name"
      echo "   Epic: $epic_name"
      if [ -n "$jira_key" ] && [ "$jira_key" != "(will be set on sync)" ]; then
        echo "   Jira: $jira_key"
      fi
      echo ""
      found=$((found + 1))
    done
  done
fi

echo "Active epics:"
for epic_dir in epics/*/; do
  [ -d "$epic_dir" ] || continue
  [ -f "$epic_dir/epic.md" ] || continue

  status=$(grep "^status:" "$epic_dir/epic.md" | head -1 | sed 's/^status: *//')
  if [ "$status" = "in-progress" ] || [ "$status" = "active" ]; then
    epic_name=$(grep "^name:" "$epic_dir/epic.md" | head -1 | sed 's/^name: *//')
    progress=$(grep "^progress:" "$epic_dir/epic.md" | head -1 | sed 's/^progress: *//')
    [ -z "$epic_name" ] && epic_name=$(basename "$epic_dir")
    [ -z "$progress" ] && progress="0%"
    echo "   - $epic_name - $progress"
  fi
done

echo ""
if [ "$found" -eq 0 ]; then
  echo "No tasks with status: in-progress. Set status: in-progress in a work item frontmatter to flag active work."
  echo ""
else
  echo "Tasks marked in-progress: $found"
fi

exit 0
