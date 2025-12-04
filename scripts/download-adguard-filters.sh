#!/bin/bash
#
# Download AdGuard Safari-Optimized Filter Lists
# These are the same filters used by wBlock for superior blocking effectiveness
#
# Based on wBlock's FilterListLoader.swift configuration:
# https://github.com/wBlock/wBlock (FilterListLoader.swift lines 136-149)
#

set -e

FILTER_DIR="filter-lists"
RULES_DIR="AdsBlocker/Shared (Extension)/Resources/rules"

echo "=== AdGuard Safari-Optimized Filter Downloader ==="
echo ""
echo "Creating directories..."
mkdir -p "$FILTER_DIR"
mkdir -p "$RULES_DIR"

echo ""
echo "Downloading AdGuard Safari-optimized filter lists..."
echo "These filters are pre-optimized for Safari's declarativeNetRequest API"
echo ""

# Primary Filters (Selected by default in wBlock)
echo "[1/6] AdGuard Base Filter (Ads blocking)..."
curl -L -s "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/platforms/extension/safari/filters/2_optimized.txt" \
  -o "$FILTER_DIR/adguard-base.txt"

echo "[2/6] AdGuard Tracking Protection Filter..."
curl -L -s "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/platforms/extension/safari/filters/3_optimized.txt" \
  -o "$FILTER_DIR/adguard-tracking.txt"

echo "[3/6] EasyPrivacy (Safari-optimized)..."
curl -L -s "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/platforms/extension/safari/filters/118_optimized.txt" \
  -o "$FILTER_DIR/easyprivacy.txt"

echo "[4/6] Peter Lowe's Blocklist (Safari-optimized)..."
curl -L -s "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/platforms/extension/safari/filters/204_optimized.txt" \
  -o "$FILTER_DIR/peter-lowe.txt"

echo "[5/6] d3Host List by d3ward..."
curl -L -s "https://raw.githubusercontent.com/d3ward/toolz/master/src/d3host.adblock" \
  -o "$FILTER_DIR/d3host.txt"

echo "[6/6] Online Security Filter..."
curl -L -s "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/platforms/extension/safari/filters/208_optimized.txt" \
  -o "$FILTER_DIR/security.txt"

echo ""
echo "Download complete!"
echo ""

# Count rules in each file
echo "Filter Statistics:"
echo "-----------------"
for file in "$FILTER_DIR"/*.txt; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        # Count non-empty lines that aren't comments
        count=$(grep -v '^[[:space:]]*$' "$file" | grep -v '^!' | grep -v '^\[' | wc -l | tr -d ' ')
        printf "%-30s %6s rules\n" "$filename" "$count"
    fi
done

echo ""
echo "Next steps:"
echo "1. Convert these filters to Safari JSON format using scripts/convert-filters-to-json.sh"
echo "2. Or manually convert using adblock-rust CLI"
echo "3. Rebuild the project"
echo ""
echo "Note: These AdGuard filters are pre-optimized for Safari and should provide"
echo "significantly better blocking effectiveness than basic EasyList."
