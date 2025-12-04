#!/bin/bash
#
# Generate Safari-Compatible Blocking Rules
# Uses url-filter patterns instead of if-domain (which Safari may not support properly)
#

set -e

RULES_DIR="AdsBlocker/Shared (Extension)/Resources/rules"

echo "=== Generating Safari-Compatible Blocking Rules ==="
echo ""
echo "Creating rules directory..."
mkdir -p "$RULES_DIR"

# Generate ads.json with Safari-compatible URL patterns
echo "Generating ads.json with Safari-compatible patterns..."
cat > "$RULES_DIR/ads.json" << 'EOF'
[
  {
    "id": 1,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "doubleclick.net",
      "resourceTypes": ["script", "image", "stylesheet", "xmlhttprequest", "other"]
    }
  },
  {
    "id": 2,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "googlesyndication.com",
      "resourceTypes": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "id": 3,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "googleadservices.com",
      "resourceTypes": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "id": 4,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "googletagservices.com",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 5,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "pagead2.googlesyndication.com",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 6,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "facebook.com/tr",
      "resourceTypes": ["script", "xmlhttprequest", "other"]
    }
  },
  {
    "id": 7,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "connect.facebook.net",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 8,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "taboola.com",
      "resourceTypes": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "id": 9,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "outbrain.com",
      "resourceTypes": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "id": 10,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "revcontent.com",
      "resourceTypes": ["script", "image"]
    }
  },
  {
    "id": 11,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "mgid.com",
      "resourceTypes": ["script", "image"]
    }
  },
  {
    "id": 12,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "criteo.com",
      "resourceTypes": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "id": 13,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "criteo.net",
      "resourceTypes": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "id": 14,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "rubiconproject.com",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 15,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "pubmatic.com",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 16,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "adnxs.com",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 17,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "amazon-adsystem.com",
      "resourceTypes": ["script", "image"]
    }
  },
  {
    "id": 18,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "moatads.com",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 19,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "openx.net",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 20,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "adform.net",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  }
]
EOF

# Generate tracking.json
echo "Generating tracking.json with Safari-compatible patterns..."
cat > "$RULES_DIR/tracking.json" << 'EOF'
[
  {
    "id": 1001,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "google-analytics.com",
      "resourceTypes": ["script", "xmlhttprequest", "other"]
    }
  },
  {
    "id": 1002,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "googletagmanager.com",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 1003,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "facebook.com/tr",
      "resourceTypes": ["xmlhttprequest", "other"]
    }
  },
  {
    "id": 1004,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "mixpanel.com",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 1005,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "segment.com",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 1006,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "segment.io",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 1007,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "hotjar.com",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 1008,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "mouseflow.com",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 1009,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "amplitude.com",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 1010,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "heap.io",
      "resourceTypes": ["script", "xmlhttprequest"]
    }
  },
  {
    "id": 1011,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "fullstory.com",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 1012,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "logrocket.com",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 1013,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "scorecardresearch.com",
      "resourceTypes": ["script", "image"]
    }
  },
  {
    "id": 1014,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "quantserve.com",
      "resourceTypes": ["script", "image"]
    }
  },
  {
    "id": 1015,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "chartbeat.com",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 1016,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "newrelic.com",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 1017,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "sentry.io",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 1018,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "clarity.ms",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 1019,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "branch.io",
      "resourceTypes": ["script"]
    }
  },
  {
    "id": 1020,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "appsflyer.com",
      "resourceTypes": ["script"]
    }
  }
]
EOF

echo ""
echo "✅ Safari-compatible rules generated!"
echo ""
echo "Key changes from previous version:"
echo "- Changed from 'trigger/if-domain' to 'condition/urlFilter' (Safari format)"
echo "- Added unique 'id' field for each rule (required by Safari)"
echo "- Changed 'resource-type' to 'resourceTypes' (correct Safari syntax)"
echo "- Uses urlFilter pattern matching instead of domain lists"
echo ""
echo "Total rules: 40 (20 ads + 20 tracking)"
echo ""
echo "Next step: Rebuild the project"
echo "xcodebuild -workspace AdsBlocker.xcworkspace -scheme 'AdsBlocker (macOS)' clean build"
