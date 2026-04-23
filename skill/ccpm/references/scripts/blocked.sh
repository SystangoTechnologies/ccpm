#!/bin/bash
echo "Getting tasks..."
echo ""
echo ""

echo "🚫 Blocked Tasks"
echo "================"
echo ""

found=0

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

    # Check for dependencies
    deps_line=$(grep "^depends_on:" "$task_file" | head -1)
    if [ -n "$deps_line" ]; then
      deps=$(echo "$deps_line" | sed 's/^depends_on: *//' | sed 's/^\[//' | sed 's/\]$//' | sed 's/,/ /g' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
      [ -z "$deps" ] && deps=""
    else
      deps=""
    fi

    if [ -n "$deps" ] && [ "$deps" != "depends_on:" ]; then
      task_name=$(grep "^name:" "$task_file" | head -1 | sed 's/^name: *//')
      task_id=$(grep "^task_id:" "$task_file" | head -1 | sed 's/^task_id: *//')
      jira_key=$(grep "^jira_key:" "$task_file" | head -1 | sed 's/^jira_key: *//')
      [ -z "$task_id" ] && task_id=$(basename "$task_file" .md)

      echo "⏸️ Task $task_id - $task_name"
      echo "   Epic: $epic_name"
      [ -n "$jira_key" ] && echo "   Jira: $jira_key"
      echo "   Blocked by: [$deps]"

      # Check status of dependencies
      open_deps=""
      for dep in $deps; do
        dep=$(echo "$dep" | sed 's/"//g' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        dep_file="$epic_dir/$dep.md"
        if [ -f "$dep_file" ]; then
          dep_status=$(grep "^status:" "$dep_file" | head -1 | sed 's/^status: *//')
          if [ "$dep_status" = "open" ] || [ "$dep_status" = "in-progress" ]; then
            open_deps="$open_deps $dep"
          fi
        else
          open_deps="$open_deps $dep(missing)"
        fi
      done

      [ -n "$open_deps" ] && echo "   Waiting for:$open_deps"
      echo ""
      ((found++))
    fi
  done
done

if [ $found -eq 0 ]; then
  echo "No blocked tasks found!"
  echo ""
  echo "💡 All tasks with dependencies are either completed or in progress."
else
  echo "📊 Total blocked: $found tasks"
fi

exit 0
