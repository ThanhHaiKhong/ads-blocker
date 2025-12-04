#!/bin/bash
#
# Generate Comprehensive Safari Blocking Rules
# Combines insights from AdGuard filters and manual rule patterns
# for immediate blocking improvement without requiring adblock-rust CLI
#

set -e

RULES_DIR="AdsBlocker/Shared (Extension)/Resources/rules"

echo "=== Generating Comprehensive Blocking Rules ==="
echo ""
echo "Creating rules directory..."
mkdir -p "$RULES_DIR"

# Generate ads.json with comprehensive ad blocking rules
echo "Generating ads.json with comprehensive patterns..."
cat > "$RULES_DIR/ads.json" << 'EOF'
[
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*doubleclick.net",
        "*googlesyndication.com",
        "*googleadservices.com",
        "*googletagservices.com",
        "*google-analytics.com",
        "*adservice.google.com",
        "*pagead2.googlesyndication.com"
      ],
      "resource-type": ["script", "image", "stylesheet", "xmlhttprequest", "other"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*facebook.com/tr",
        "*facebook.com/plugins",
        "*connect.facebook.net",
        "*facebook.net/en_US/all.js"
      ],
      "resource-type": ["script", "xmlhttprequest", "other"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*taboola.com",
        "*outbrain.com",
        "*revcontent.com",
        "*mgid.com",
        "*content-ad.net",
        "*contentabc.com"
      ],
      "resource-type": ["script", "image", "stylesheet", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*criteo.com",
        "*criteo.net",
        "*rubiconproject.com",
        "*pubmatic.com",
        "*adnxs.com",
        "*adsrvr.org"
      ],
      "resource-type": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*advertising.com",
        "*adsystem.com",
        "*adtech.de",
        "*247realmedia.com",
        "*serving-sys.com",
        "*media.net"
      ],
      "resource-type": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/(ads?|advert|banner|sponsor|popup|tracking)",
      "resource-type": ["script", "image", "stylesheet"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/ad[sx]?\\.js",
      "resource-type": ["script"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/advertisement",
      "resource-type": ["script", "image", "stylesheet"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/(pagead|show_ads|adsbygoogle)",
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*amazon-adsystem.com",
        "*adsafeprotected.com",
        "*moatads.com",
        "*advertising.amazon.com"
      ],
      "resource-type": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*openx.net",
        "*adform.net",
        "*smartadserver.com",
        "*yieldmo.com"
      ],
      "resource-type": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*index exchange.com",
        "*contextweb.com",
        "*improvedigital.com",
        "*casalemedia.com"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/(leaderboard|skyscraper|rectangle|banner_)",
      "resource-type": ["image", "stylesheet"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*ad.doubleclick.net",
        "*static.doubleclick.net",
        "*m.doubleclick.net",
        "*stats.g.doubleclick.net"
      ],
      "resource-type": ["script", "image", "xmlhttprequest", "other"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*bidswitch.net",
        "*sharethrough.com",
        "*teads.tv",
        "*stroeer.de"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/[_-]?ad[sx]?[_-]?\\d+x\\d+",
      "resource-type": ["image"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*33across.com",
        "*sovrn.com",
        "*triplelift.com",
        "*spotxchange.com"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/(adframe|iframe[_-]?ad|ad[_-]?iframe)",
      "resource-type": ["script", "document"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*advertising.apple.com",
        "*iadsdk.apple.com",
        "*metrics.apple.com"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/(sponsor|promo)[_-]?(ad|banner)",
      "resource-type": ["image", "script"]
    }
  }
]
EOF

# Generate tracking.json with comprehensive tracking protection
echo "Generating tracking.json with privacy protection..."
cat > "$RULES_DIR/tracking.json" << 'EOF'
[
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*google-analytics.com",
        "*googletagmanager.com",
        "*googletagservices.com",
        "*analytics.google.com"
      ],
      "resource-type": ["script", "xmlhttprequest", "other"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*facebook.com/tr",
        "*facebook.com/plugins/like",
        "*connect.facebook.net/en_US/fbevents.js",
        "*facebook.net/signals"
      ],
      "resource-type": ["script", "xmlhttprequest", "other"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*mixpanel.com",
        "*segment.com",
        "*segment.io",
        "*cdn.segment.com"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*hotjar.com",
        "*mouseflow.com",
        "*luckyorange.com",
        "*inspectlet.com"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*amplitude.com",
        "*heap.io",
        "*fullstory.com",
        "*logrocket.com"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*scorecardresearch.com",
        "*quantserve.com",
        "*quantcount.com",
        "*chartbeat.com"
      ],
      "resource-type": ["script", "xmlhttprequest", "image"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/(analytics|tracking|telemetry|beacon)",
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/track(ing)?\\.(js|gif|png)",
      "resource-type": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*newrelic.com",
        "*nr-data.net",
        "*bugsnag.com",
        "*sentry.io"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*optimizely.com",
        "*cdn.optimizely.com",
        "*google-analytics.com/analytics.js"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*stats.wp.com",
        "*pixel.wp.com",
        "*stats.wordpress.com"
      ],
      "resource-type": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/collect\\?.*v=1.*tid=UA-",
      "resource-type": ["xmlhttprequest", "image"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/(pixel|impression|analytics)\\.(gif|png|jpg)",
      "resource-type": ["image"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*bat.bing.com",
        "*clarity.ms",
        "*c.bing.com"
      ],
      "resource-type": ["script", "xmlhttprequest", "image"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*omtrdc.net",
        "*demdex.net",
        "*everesttech.net",
        "*2o7.net"
      ],
      "resource-type": ["script", "xmlhttprequest", "image"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/utm_(source|medium|campaign|content|term)=",
      "resource-type": ["xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/(fbclid|gclid|msclkid|mc_eid)=",
      "resource-type": ["xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*crazyegg.com",
        "*clicktale.net",
        "*sessioncam.com"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*",
      "if-domain": [
        "*branch.io",
        "*adjust.com",
        "*appsflyer.com",
        "*kochava.com"
      ],
      "resource-type": ["script", "xmlhttprequest"]
    }
  },
  {
    "action": {
      "type": "block"
    },
    "trigger": {
      "url-filter": ".*/fingerprint",
      "resource-type": ["script", "xmlhttprequest"]
    }
  }
]
EOF

echo ""
echo "✅ Rules generated successfully!"
echo ""
echo "Summary:"
echo "--------"

ads_count=$(cat "$RULES_DIR/ads.json" | grep -c '"action"' || echo "0")
tracking_count=$(cat "$RULES_DIR/tracking.json" | grep -c '"action"' || echo "0")
total_count=$((ads_count + tracking_count))

echo "Ads blocking rules:      $ads_count"
echo "Tracking blocking rules: $tracking_count"
echo "Total rules:             $total_count"
echo ""

echo "Key improvements over previous rules:"
echo "- Added major ad networks (Google, Facebook, Amazon, Criteo, etc.)"
echo "- Added native ad networks (Taboola, Outbrain, Revcontent, MGID)"
echo "- Added programmatic ad exchanges (Rubicon, PubMatic, AppNexus)"
echo "- Added comprehensive analytics blocking (GA, Mixpanel, Hotjar, Amplitude)"
echo "- Added session replay blocking (FullStory, LogRocket, SessionCam)"
echo "- Added mobile attribution tracking (Branch, Adjust, AppsFlyer)"
echo "- Added URL tracking parameter blocking (utm_, fbclid, gclid)"
echo ""

echo "Next steps:"
echo "1. Rebuild the project: xcodebuild -workspace AdsBlocker.xcworkspace -scheme 'AdsBlocker (macOS)' build"
echo "2. Test on https://iblockads.net/test"
echo "3. Compare blocking effectiveness (previously 28%)"
echo ""

echo "For even better results, run scripts/download-adguard-filters.sh"
echo "to download AdGuard's full Safari-optimized filter lists."
