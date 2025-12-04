#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}AdsBlocker - Update Filter Rules${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Directories
FILTER_DIR="filter-lists"
RULES_DIR="AdsBlocker/Shared (Extension)/Resources/rules"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Create directories if they don't exist
mkdir -p "$FILTER_DIR"
mkdir -p "$RULES_DIR"

# Check if adblock CLI is installed
if ! command -v adblock &> /dev/null; then
    echo -e "${RED}Error: adblock CLI not found${NC}"
    echo ""
    echo "Please install Rust and adblock-rust CLI:"
    echo "  1. Install Rust: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    echo "  2. Install adblock: cargo install adblock"
    echo ""
    exit 1
fi

echo -e "${YELLOW}Downloading filter lists...${NC}"
echo ""

# Download EasyList (ads)
echo "- Downloading EasyList..."
curl -L --progress-bar https://easylist.to/easylist/easylist.txt -o "$FILTER_DIR/easylist.txt"

# Download EasyPrivacy (tracking)
echo "- Downloading EasyPrivacy..."
curl -L --progress-bar https://easylist.to/easylist/easyprivacy.txt -o "$FILTER_DIR/easyprivacy.txt"

echo ""
echo -e "${YELLOW}Converting filter lists to Safari format...${NC}"
echo ""

# Convert to Safari Content Blocker format
echo "- Converting EasyList to ads.json..."
adblock convert safari -i "$FILTER_DIR/easylist.txt" -o "$RULES_DIR/ads.json"

echo "- Converting EasyPrivacy to tracking.json..."
adblock convert safari -i "$FILTER_DIR/easyprivacy.txt" -o "$RULES_DIR/tracking.json"

echo ""
echo -e "${GREEN}✓ Filter rules updated successfully!${NC}"
echo ""

# Display statistics
echo "Rule statistics:"
echo "- ads.json: $(jq '. | length' "$RULES_DIR/ads.json" 2>/dev/null || echo "unknown") rules"
echo "- tracking.json: $(jq '. | length' "$RULES_DIR/tracking.json" 2>/dev/null || echo "unknown") rules"
echo ""

echo -e "${YELLOW}Note: Rebuild the project in Xcode to apply the new rules.${NC}"
echo ""
