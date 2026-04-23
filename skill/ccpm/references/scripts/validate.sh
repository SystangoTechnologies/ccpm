#!/bin/bash

echo "Validating PM System..."
echo ""
echo ""

echo "🔍 Validating PM System"
echo "======================="
echo ""

errors=0
warnings=0

# Check directory structure
echo "📁 Directory Structure:"
[ -d "prds" ] && echo "  ✅ PRDs directory exists" || echo "  ⚠️ PRDs directory missing"
[ -d "epics" ] && echo "  ✅ Epics directory exists" || echo "  ⚠️ Epics directory missing"
[ -d "context" ] && echo "  ✅ Context directory exists" || echo "  ⚠️ Context directory missing"
echo ""

# Check for orphaned files
echo "🗂️ Data Integrity:"

# Check epics have epic.md files
for epic_dir in epics/*/; do
  [ -d "$epic_dir" ] || continue
  if [ ! -f "$epic_dir/epic.md" ]; then
    echo "  ⚠️ Missing epic.md in $(basename "$epic_dir")"
    ((warnings++))
  fi
done

# Check for tasks without epics
orphaned=$(find . -name "T*.md" -not -path "./epics/*/*" 2>/dev/null | wc -l)
[ $orphaned -gt 0 ] && echo "  ⚠️ Found $orphaned orphaned task files" && ((warnings++))

# Check for broken references
echo ""
echo "🔗 Reference Check:"

for task_file in epics/*/T*.md; do
  [ -f "$task_file" ] || continue

  deps_line=$(grep "^depends_on:" "$task_file" | head -1)
  if [ -n "$deps_line" ]; then
    deps=$(echo "$deps_line" | sed 's/^depends_on: *//' | sed 's/^\[//' | sed 's/\]$//' | sed 's/,/ /g' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    [ -z "$deps" ] && deps=""
  else
    deps=""
  fi
  if [ -n "$deps" ] && [ "$deps" != "depends_on:" ]; then
    epic_dir=$(dirname "$task_file")
    for dep in $deps; do
      dep=$(echo "$dep" | sed 's/"//g' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
      if [ ! -f "$epic_dir/$dep.md" ]; then
        echo "  ⚠️ Task $(basename "$task_file" .md) references missing task: $dep"
        ((warnings++))
      fi
    done
  fi
done

missing_jira=0
for task_file in epics/*/T*.md; do
  [ -f "$task_file" ] || continue
  if ! grep -q "^jira_key:" "$task_file"; then
    echo "  ⚠️ Missing jira_key in $(basename "$task_file")"
    ((warnings++))
    ((missing_jira++))
  fi
done

if [ $warnings -eq 0 ] && [ $errors -eq 0 ] && [ $missing_jira -eq 0 ]; then
  echo "  ✅ All references valid"
fi

# Check frontmatter
echo ""
echo "📝 Frontmatter Validation:"
invalid=0

for file in $(find epics prds -name "*.md" 2>/dev/null); do
  if ! grep -q "^---" "$file"; then
    echo "  ⚠️ Missing frontmatter: $(basename "$file")"
    ((invalid++))
  fi
done

[ $invalid -eq 0 ] && echo "  ✅ All files have frontmatter"

# Summary
echo ""
echo "📊 Validation Summary:"
echo "  Errors: $errors"
echo "  Warnings: $warnings"
echo "  Invalid files: $invalid"

if [ $errors -eq 0 ] && [ $warnings -eq 0 ] && [ $invalid -eq 0 ]; then
  echo ""
  echo "✅ System is healthy!"
else
  echo ""
  echo "💡 Run /pm:clean to fix some issues automatically"
fi

exit 0
