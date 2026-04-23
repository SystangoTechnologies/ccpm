#!/bin/bash
echo "Getting status..."
echo ""
echo ""

echo "📋 Next Available Tasks"
echo "======================="
echo ""

# Find tasks that are open and have no dependencies or whose dependencies are closed
found=0

is_task_ready() {
  local epic_dir="$1"
  local task_file="$2"
  local deps_line deps dep dep_file dep_status

  deps_line=$(grep "^depends_on:" "$task_file" | head -1)
  deps=$(echo "$deps_line" | sed 's/^depends_on: *//' | sed 's/^\[//' | sed 's/\]$//' | sed 's/,/ /g' | sed 's/"//g' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
  [ -z "$deps" ] && return 0

  for dep in $deps; do
    dep=$(echo "$dep" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    [ -z "$dep" ] && continue
    dep_file="$epic_dir/$dep.md"
    if [ ! -f "$dep_file" ]; then
      return 1
    fi
    dep_status=$(grep "^status:" "$dep_file" | head -1 | sed 's/^status: *//')
    if [ "$dep_status" != "closed" ] && [ "$dep_status" != "completed" ]; then
      return 1
    fi
  done

  return 0
}

for epic_dir in epics/*/; do
  [ -d "$epic_dir" ] || continue
  epic_name=$(basename "$epic_dir")

  for task_file in "$epic_dir"/T*.md; do
    [ -f "$task_file" ] || continue

    # Check if task is open
    status=$(grep "^status:" "$task_file" | head -1 | sed 's/^status: *//')
    if [ "$status" != "open" ] && [ -n "$status" ]; then
      continue
    fi

    if is_task_ready "$epic_dir" "$task_file"; then
      task_name=$(grep "^name:" "$task_file" | head -1 | sed 's/^name: *//')
      task_id=$(grep "^task_id:" "$task_file" | head -1 | sed 's/^task_id: *//')
      jira_key=$(grep "^jira_key:" "$task_file" | head -1 | sed 's/^jira_key: *//')
      [ -z "$task_id" ] && task_id=$(basename "$task_file" .md)
      parallel=$(grep "^parallel:" "$task_file" | head -1 | sed 's/^parallel: *//')

      echo "✅ Ready: $task_id - $task_name"
      echo "   Epic: $epic_name"
      [ -n "$jira_key" ] && echo "   Jira: $jira_key"
      [ "$parallel" = "true" ] && echo "   🔄 Can run in parallel"
      echo ""
      ((found++))
    fi
  done
done

if [ $found -eq 0 ]; then
  echo "No available tasks found."
  echo ""
  echo "💡 Suggestions:"
  echo "  • Check blocked tasks: /pm:blocked"
  echo "  • View all tasks: /pm:epic-list"
fi

echo ""
echo "📊 Summary: $found tasks ready to start"

exit 0
