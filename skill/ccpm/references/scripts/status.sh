#!/bin/bash

echo "Getting status..."
echo ""
echo ""


echo "📊 Project Status"
echo "================"
echo ""

echo "📄 PRDs:"
if [ -d "prds" ]; then
  total=$(ls prds/*.md 2>/dev/null | wc -l)
  echo "  Total: $total"
else
  echo "  No PRDs found"
fi

echo ""
echo "📚 Epics:"
if [ -d "epics" ]; then
  total=$(ls -d epics/*/ 2>/dev/null | grep -v '/archived/$' | wc -l)
  echo "  Total: $total"
else
  echo "  No epics found"
fi

echo ""
echo "📝 Tasks:"
if [ -d "epics" ]; then
  total=$(find epics -path "*/archived/*" -prune -o -name "T*.md" -print 2>/dev/null | wc -l)
  open=$(find epics -path "*/archived/*" -prune -o -name "T*.md" -print 2>/dev/null | xargs grep -l "^status: *open" 2>/dev/null | wc -l)
  closed=$(find epics -path "*/archived/*" -prune -o -name "T*.md" -print 2>/dev/null | xargs grep -l "^status: *closed" 2>/dev/null | wc -l)
  echo "  Open: $open"
  echo "  Closed: $closed"
  echo "  Total: $total"
else
  echo "  No tasks found"
fi

exit 0
