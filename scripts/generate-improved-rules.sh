#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Generating Improved Ad Blocking Rules${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

RULES_DIR="AdsBlocker/Shared (Extension)/Resources/rules"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Create rules directory if it doesn't exist
mkdir -p "$RULES_DIR"

echo -e "${YELLOW}Generating comprehensive rules...${NC}"
echo ""

# Generate ads.json with common ad networks and patterns
cat > "$RULES_DIR/ads.json" << 'EOF'
[
  {
    "id": 1,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||doubleclick.net^",
      "resourceTypes": ["script", "xmlhttprequest", "image", "subdocument"]
    }
  },
  {
    "id": 2,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||googleadservices.com^",
      "resourceTypes": ["script", "xmlhttprequest", "image"]
    }
  },
  {
    "id": 3,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||googlesyndication.com^",
      "resourceTypes": ["script", "xmlhttprequest", "subdocument"]
    }
  },
  {
    "id": 4,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||google-analytics.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 5,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||googletagmanager.com^",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 6,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||googletagservices.com^",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 7,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||pagead2.googlesyndication.com^",
      "resourceTypes": ["script", "xmlhttprequest", "subdocument"]
    }
  },
  {
    "id": 8,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||facebook.com/tr/",
      "resourceTypes": ["xmlhttprequest", "image"]
    }
  },
  {
    "id": 9,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||connect.facebook.net/*/fbevents.js",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 10,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||ads.facebook.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 11,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||adnxs.com^",
      "resourceTypes": ["script", "xmlhttprequest", "subdocument"]
    }
  },
  {
    "id": 12,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||amazon-adsystem.com^",
      "resourceTypes": ["script", "xmlhttprequest", "subdocument"]
    }
  },
  {
    "id": 13,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||taboola.com^",
      "resourceTypes": ["script", "xmlhttprequest", "subdocument"]
    }
  },
  {
    "id": 14,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||outbrain.com^",
      "resourceTypes": ["script", "xmlhttprequest", "subdocument"]
    }
  },
  {
    "id": 15,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||criteo.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 16,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||pubmatic.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 17,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||scorecardresearch.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 18,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||quantserve.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 19,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||moatads.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 20,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||rubiconproject.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 21,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||2mdn.net^",
      "resourceTypes": ["script", "xmlhttprequest", "image"]
    }
  },
  {
    "id": 22,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||advertising.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 23,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||adsafeprotected.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 24,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||adsystem.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 25,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||adtechus.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 26,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||advertising.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 27,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||casalemedia.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 28,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||yieldmo.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 29,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||smartadserver.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 30,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||openx.net^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 31,
    "priority": 2,
    "action": {"type": "block"},
    "condition": {
      "regexFilter": "/adframe|adsbygoogle|advertising|sponsor|promoted",
      "resourceTypes": ["script", "subdocument"]
    }
  },
  {
    "id": 32,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||media.net^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 33,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||viglink.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 34,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||addthis.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 35,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||sharethis.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  }
]
EOF

# Generate tracking.json
cat > "$RULES_DIR/tracking.json" << 'EOF'
[
  {
    "id": 1,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||google-analytics.com/analytics.js",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 2,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||google-analytics.com/ga.js",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 3,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||google-analytics.com/collect",
      "resourceTypes": ["xmlhttprequest", "image"]
    }
  },
  {
    "id": 4,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||googletagmanager.com/gtm.js",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 5,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||hotjar.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 6,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||mixpanel.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 7,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||segment.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 8,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||amplitude.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 9,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||fullstory.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 10,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||heap-api.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 11,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||pendo.io^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 12,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||newrelic.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 13,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||sentry.io^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 14,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||optimizely.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 15,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||crazyegg.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 16,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||mouseflow.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 17,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||clicktale.net^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 18,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||usabilla.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 19,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||nr-data.net^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 20,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||clarity.ms^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 21,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||stats.g.doubleclick.net^",
      "resourceTypes": ["xmlhttprequest", "image"]
    }
  },
  {
    "id": 22,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||facebook.com/tr^",
      "resourceTypes": ["xmlhttprequest", "image"]
    }
  },
  {
    "id": 23,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||twitter.com/i/adsct",
      "resourceTypes": ["xmlhttprequest", "image"]
    }
  },
  {
    "id": 24,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||analytics.twitter.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 25,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||linkedin.com/li/track",
      "resourceTypes": ["xmlhttprequest"]
    }
  },
  {
    "id": 26,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||snap.licdn.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 27,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||bizographics.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 28,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||mouseflow.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 29,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||inspectlet.com^",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 30,
    "priority": 1,
    "action": {"type": "block"},
    "condition": {
      "urlFilter": "||t.co/i/adsct",
      "resourceTypes": ["xmlhttprequest", "image"]
    }
  }
]
EOF

echo -e "${GREEN}✓ Generated improved rules!${NC}"
echo ""
echo "Rule statistics:"
echo "- ads.json: 35 rules (common ad networks)"
echo "- tracking.json: 30 rules (analytics & tracking)"
echo "- Total: 65 comprehensive rules"
echo ""
echo -e "${YELLOW}Next step: Rebuild the project in Xcode to apply these rules${NC}"
echo ""
