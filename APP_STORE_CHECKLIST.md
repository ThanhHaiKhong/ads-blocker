# App Store Submission Checklist

Quick reference for preparing and submitting AdsBlocker to the App Store.

---

## Phase 1: Code Preparation

### Production Build
- [ ] Remove developer test button from popup.html (lines 104-106)
- [ ] Remove/comment test actions in background.js:
  - `addTestStatistics` case
  - `incrementBlock` case
- [ ] Reduce console logging (keep errors only)
- [ ] Update version to 1.0 in:
  - `manifest.json` line 7
  - `Info.plist` (CFBundleShortVersionString)
- [ ] Build in Release configuration
- [ ] Test on clean device

### Code Quality
- [ ] No console errors or warnings
- [ ] All tests from TESTING.md pass
- [ ] Performance benchmarks met
- [ ] Memory leaks checked
- [ ] Works on iOS and macOS

---

## Phase 2: Assets Creation

### App Icons
Required sizes:
- [ ] 1024×1024 (App Store)
- [ ] Verify existing icons (48, 96, 128, 256, 512)
- [ ] Test icons on light/dark backgrounds
- [ ] No alpha channel in App Store icon
- [ ] PNG or JPEG format

**Location**: `AdsBlocker/Shared (App)/Assets.xcassets/`

### Screenshots

#### iOS (need 3-5 per size)
- [ ] iPhone 6.9" - 1320 × 2868 px
- [ ] iPhone 6.7" - 1290 × 2796 px
- [ ] iPhone 6.5" - 1284 × 2778 px
- [ ] iPad Pro 12.9" - 2048 × 2732 px

#### macOS
- [ ] macOS - 2880 × 1800 px (Retina)

**Suggested screenshots**:
1. Main popup with statistics (impressive numbers)
2. Protection toggles interface
3. Whitelist management
4. Before/After comparison
5. Safari integration view

**Tips**:
- Use "[Dev] Add 100 Test Blocks" multiple times for high numbers
- Add text overlays explaining features
- Show real websites with blocking active

### App Preview Video (Optional)
- [ ] 15-30 second video
- [ ] Show key features
- [ ] Demonstrate blocking
- [ ] Add captions

---

## Phase 3: App Information

### Basic Info
- [ ] **App Name**: "AdsBlocker - Fast & Private" (or choose)
- [ ] **Subtitle**: "Block Ads & Stop Trackers"
- [ ] **Category**: Utilities (Primary), Productivity (Secondary)
- [ ] **Age Rating**: 4+ (no restricted content)
- [ ] **Price**: Free

### Description
Copy from `PHASE_8_DISTRIBUTION.md` section 8.2 or customize:

```
AdsBlocker - Your Privacy Guardian

Experience faster, cleaner, and more private browsing...
[Full description in PHASE_8_DISTRIBUTION.md]
```

**Length**: ~3000-4000 characters
**Include**:
- Key features with emojis
- What gets blocked (specific examples)
- Privacy commitment
- How it works
- Supported platforms
- Limitations (be honest)

### Keywords
```
ad blocker, privacy, tracker, safari, ads, block, protection, fast, security, browse
```
(100 characters max, comma-separated)

### Promotional Text (updatable without review)
```
Browse faster and safer! Block intrusive ads and invasive trackers automatically.
Lightweight extension with no data collection.
```
(170 characters max)

### Support & Contact
- [ ] Create support email: `support@adsblocker.app` (or alternative)
- [ ] Create privacy policy URL
- [ ] Create support URL (can be GitHub)
- [ ] Add marketing website (optional)

---

## Phase 4: Legal Documents

### Privacy Policy
**Required**: Yes

**Template**: See `PHASE_8_DISTRIBUTION.md` section 8.3

**Must Include**:
- What data is collected (NONE for this app)
- What data is stored locally
- No third-party services
- No tracking or analytics
- GDPR compliance statement
- Contact information

**Hosting Options**:
1. GitHub Pages (free, easy)
2. Simple static site
3. Include in app bundle

**Action**:
- [ ] Write privacy policy using template
- [ ] Host publicly accessible URL
- [ ] Add link to App Store Connect
- [ ] Include "Privacy" section in app (optional)

### Terms of Service
**Required**: No (optional for free utility apps)

**If including**:
- Standard disclaimer
- No warranty statements
- Limitation of liability
- User responsibilities

---

## Phase 5: App Store Connect Setup

### Prerequisites
- [ ] Apple Developer Program membership ($99/year)
- [ ] App Store Connect account set up
- [ ] Certificates configured in Xcode
- [ ] Provisioning profiles created

### Create App Listing

1. **Login to App Store Connect**
   - https://appstoreconnect.apple.com

2. **My Apps > + > New App**
   - Platform: iOS, macOS (or both)
   - Name: AdsBlocker
   - Primary Language: English
   - Bundle ID: com.thanhhaikhong.AdsBlocker
   - SKU: ADSBLOCKER001 (unique identifier)

3. **Fill App Information**
   - [ ] App Name
   - [ ] Subtitle
   - [ ] Privacy Policy URL
   - [ ] Category
   - [ ] Age Rating
   - [ ] Description
   - [ ] Keywords
   - [ ] Support URL
   - [ ] Marketing URL (optional)

4. **Upload Build**
   - Xcode > Product > Archive
   - Window > Organizer
   - Select archive > Distribute App
   - App Store Connect > Upload
   - Wait for processing (~30 min)

5. **Add Screenshots**
   - Upload all required sizes
   - Add captions/descriptions
   - Reorder for best presentation

6. **Pricing and Availability**
   - Free
   - All territories (or select specific)
   - Available immediately

7. **App Review Information**
   - [ ] Contact information (phone, email)
   - [ ] Demo account (if needed - not required for this app)
   - [ ] Review notes:
   ```
   AdsBlocker is a Safari extension that blocks ads and trackers.

   To test:
   1. Enable extension in Settings > Safari > Extensions
   2. Visit any website (e.g., forbes.com)
   3. Click extension icon to see blocked count

   Note: Statistics may not update on Safari due to API limitations.
   This is documented in the app description. Blocking still works.

   All blocking happens locally. No data collection.
   ```
   - [ ] Attachments (optional screenshots showing how to test)

8. **Version Information**
   - [ ] Version: 1.0
   - [ ] Copyright: © 2024 [Your Name]
   - [ ] What's New: "Initial release"

9. **Submit for Review**
   - Double-check all information
   - Click "Submit for Review"
   - Wait for confirmation email

---

## Phase 6: Review Process

### Timeline
- **Processing**: ~30 min after upload
- **In Review**: Usually 1-3 days
- **Total**: ~1-5 days

### What Happens
1. Build processing (automated)
2. Preliminary review (automated checks)
3. Human review (1-3 days)
4. Approval or rejection

### If Approved
- [ ] App goes live (or scheduled release)
- [ ] Download and verify
- [ ] Share with friends/beta testers
- [ ] Monitor reviews
- [ ] Respond to feedback

### If Rejected
Common reasons:
- Incomplete functionality
- Misleading description
- Privacy issues
- UI problems

**Actions**:
- Read rejection reason carefully
- Fix issues
- Respond to reviewer
- Resubmit

---

## Phase 7: Post-Launch

### Immediate (Day 1)
- [ ] Download from App Store to verify
- [ ] Test basic functionality
- [ ] Monitor crash reports (Xcode Organizer)
- [ ] Check first reviews
- [ ] Post announcement (social media, website)

### Week 1
- [ ] Respond to all reviews (especially negative)
- [ ] Fix any critical bugs discovered
- [ ] Update FAQ based on questions
- [ ] Gather user feedback
- [ ] Monitor performance

### Month 1
- [ ] Analyze user feedback themes
- [ ] Plan first update (bug fixes)
- [ ] Update blocking rules if needed
- [ ] Consider feature requests
- [ ] Review analytics (if added)

### Ongoing
- [ ] Monthly rule updates
- [ ] Respond to reviews weekly
- [ ] Fix bugs promptly
- [ ] Add features based on feedback
- [ ] Keep documentation updated

---

## Quick Reference: File Locations

```
Code Changes:
- AdsBlocker/Shared (Extension)/Resources/popup.html (remove test button)
- AdsBlocker/Shared (Extension)/Resources/background.js (remove test actions)
- AdsBlocker/Shared (Extension)/Resources/manifest.json (version)

Assets:
- AdsBlocker/Shared (App)/Assets.xcassets/ (icons)
- Screenshots/ (create folder for organization)

Documentation:
- Privacy Policy (host externally)
- User Guide (optional, can be on GitHub)
- Support page (can be GitHub Issues)
```

---

## Helpful Commands

### Build Archive
```bash
# iOS
xcodebuild -workspace AdsBlocker.xcworkspace \
  -scheme "AdsBlocker (iOS)" \
  -configuration Release \
  -archivePath build/AdsBlocker-iOS.xcarchive \
  archive

# macOS
xcodebuild -workspace AdsBlocker.xcworkspace \
  -scheme "AdsBlocker (macOS)" \
  -configuration Release \
  -archivePath build/AdsBlocker-macOS.xcarchive \
  archive
```

### Version Update
```bash
# Update manifest.json version
# Update Info.plist version
# Tag in git:
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

---

## Tips for Success

### Before Submission
1. **Test, test, test** - Use TESTING.md checklist
2. **Clean build** - Test on fresh device without development data
3. **Be honest** - Document limitations clearly
4. **Good screenshots** - They're your first impression
5. **Clear description** - Explain what it does simply

### During Review
1. **Be responsive** - Reply to reviewer questions quickly
2. **Be patient** - Review takes 1-3 days typically
3. **Don't panic** - Rejections are common, just fix and resubmit

### After Launch
1. **Monitor closely** - First week is critical
2. **Fix bugs fast** - Critical bugs need immediate updates
3. **Thank users** - Respond to positive reviews
4. **Learn from feedback** - Users will find issues you missed
5. **Update regularly** - Shows app is maintained

---

## Common Mistakes to Avoid

❌ **Don't**:
- Submit without thorough testing
- Make exaggerated claims in description
- Ignore limitations or lie about capabilities
- Forget to test on real devices
- Submit with test/debug code visible
- Use copyrighted material without permission
- Collect data without privacy policy

✅ **Do**:
- Test everything in TESTING.md
- Be honest about what app can/cannot do
- Document known limitations
- Test on multiple devices/OS versions
- Remove all developer/test features
- Create original assets
- Have clear, comprehensive privacy policy

---

## Emergency Contacts

If you have issues:

- **App Store Connect Help**: https://developer.apple.com/support/
- **Review Guidelines**: https://developer.apple.com/app-store/review/guidelines/
- **Safari Extension Docs**: https://developer.apple.com/documentation/safariservices
- **Stack Overflow**: Tag questions with [safari-extension]

---

## Status Tracking

### Current Status
- [x] Phase 1-7 complete
- [ ] Production code cleanup
- [ ] Assets created
- [ ] App Store Connect setup
- [ ] Submission
- [ ] Review
- [ ] Launch

### Next Immediate Steps
1. ✅ Verify statistics fix works (USER ACTION)
2. Remove developer features
3. Create 1024x1024 icon
4. Take screenshots
5. Write privacy policy
6. Submit to App Store

---

**Estimated Time to Launch**: 1-2 weeks (including review)

**Good luck with your App Store submission! 🚀**
