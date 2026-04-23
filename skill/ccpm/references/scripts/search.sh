#!/bin/bash

query="$1"

if [ -z "$query" ]; then
  echo "❌ Please provide a search query"
  echo "Usage: /pm:search <query>"
  exit 1
fi

echo "Searching for '$query'..."
echo ""
echo ""

echo "🔍 Search results for: '$query'"
echo "================================"
echo ""

# Search in PRDs
if [ -d "prds" ]; then
  echo "📄 PRDs:"
  results=$(grep -l -i "$query" prds/*.md 2>/dev/null)
  if [ -n "$results" ]; then
    for file in $results; do
      name=$(basename "$file" .md)
      matches=$(grep -c -i "$query" "$file")
      echo "  • $name ($matches matches)"
    done
  else
    echo "  No matches"
  fi
  echo ""
fi

# Search in Epics
if [ -d "epics" ]; then
  echo "📚 Epics:"
  results=$(find epics -name "epic.md" -exec grep -l -i "$query" {} \; 2>/dev/null)
  if [ -n "$results" ]; then
    for file in $results; do
      epic_name=$(basename $(dirname "$file"))
      matches=$(grep -c -i "$query" "$file")
      echo "  • $epic_name ($matches matches)"
    done
  else
    echo "  No matches"
  fi
  echo ""
fi

# Search in Tasks
if [ -d "epics" ]; then
  echo "📝 Tasks:"
  results=$(find epics -name "T*.md" -exec grep -l -i "$query" {} \; 2>/dev/null | head -10)
  if [ -n "$results" ]; then
    for file in $results; do
      epic_name=$(basename $(dirname "$file"))
      task_id=$(basename "$file" .md)
      echo "  • Task $task_id in $epic_name"
    done
  else
    echo "  No matches"
  fi
fi

# Summary
total=$(find prds epics -name "*.md" -exec grep -l -i "$query" {} \; 2>/dev/null | wc -l)
echo ""
echo "📊 Total files with matches: $total"

exit 0
