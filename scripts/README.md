# AdsBlocker Scripts

This directory contains utility scripts for managing the AdsBlocker project.

## Prerequisites

### Install Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### Install adblock-rust CLI

```bash
cargo install adblock
```

Verify installation:
```bash
adblock --version
```

## Scripts

### update-rules.sh

Updates the ad blocking filter rules from the latest filter lists.

**Usage:**
```bash
./scripts/update-rules.sh
```

**What it does:**
1. Downloads the latest EasyList (ads) and EasyPrivacy (tracking) filter lists
2. Converts them to Safari's declarativeNetRequest format
3. Updates `AdsBlocker/Shared (Extension)/Resources/rules/ads.json`
4. Updates `AdsBlocker/Shared (Extension)/Resources/rules/tracking.json`

**After running:**
- Rebuild the project in Xcode to apply the new rules
- The updated rules will be included in the next build

## Filter Lists Used

- **EasyList**: https://easylist.to/easylist/easylist.txt
  - Primary ad blocking list
  - Blocks advertisements from major ad networks

- **EasyPrivacy**: https://easylist.to/easylist/easyprivacy.txt
  - Privacy protection list
  - Blocks tracking scripts and analytics

## Customization

To add more filter lists:

1. Edit `update-rules.sh`
2. Add download command for the new list
3. Convert it using `adblock convert safari`
4. Add the rule file to `manifest.json`

Example:
```bash
# Download Fanboy's Annoyances
curl -L https://secure.fanboy.co.nz/fanboy-annoyance.txt -o filter-lists/fanboy.txt

# Convert
adblock convert safari -i filter-lists/fanboy.txt -o "AdsBlocker/Shared (Extension)/Resources/rules/annoyances.json"
```

Then update `manifest.json`:
```json
{
  "id": "annoyances_ruleset",
  "enabled": true,
  "path": "rules/annoyances.json"
}
```

## Troubleshooting

### "adblock: command not found"

Make sure Rust's cargo bin is in your PATH:
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

Add to `~/.zshrc` or `~/.bash_profile` to make permanent.

### Conversion fails

- Check that filter list URLs are accessible
- Verify you have write permissions to the rules directory
- Try running with elevated permissions if needed

### Safari rule limits

Safari has a limit on the number of rules per ruleset (around 50,000-150,000 depending on the platform). If conversion produces too many rules, you may need to:

1. Use a subset of the filter list
2. Split into multiple rulesets
3. Prioritize the most important rules
