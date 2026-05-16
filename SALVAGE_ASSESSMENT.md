# PoolVibe v1 — Salvage vs. Rebuild Assessment

**Date:** 2026-05-16  
**Analyst:** Ren  
**Source:** APK binary (`app-release-0.0.1.apk`, 62.3MB), AI Drive docs, restart structure document

---

## What the ZIP actually contained

The archive `Pool Vibe-20260416T013332Z-3-001 (1).zip` contained exactly **one file**:

```
Pool Vibe/app-release-0.0.1.apk  (89MB uncompressed)
```

**There is no editable Flutter source code in this archive.** Only a compiled release APK. The Dart code has been compiled into native machine code (ARM64/ARM32/x86_64 `.so` files) and cannot be decompiled into readable Flutter/Dart files.

---

## What the APK tells us

Extracted from the binary — confirmed screens/pages built:

| Screen | Notes |
|--------|-------|
| `LoginPage` / `LoginOrRegisterPage` | Firebase Auth, biometric login option |
| `RegisterPage` | Standard registration |
| `ForgotPasswordPage` | Password reset |
| `OnboardingScreen` | Exists — unknown content |
| `MainPage` | Bottom-nav container |
| `HomeFeedPage` | Social feed (community content) |
| `CommunityHubPage` | Full community hub |
| `MessagesPage` / `ChatPage` / `CreateGroupRequestPage` | Full messaging system |
| `GroupDetailPage` | Group chats |
| `NotificationsPage` | Push notifications (Firebase FCM) |
| `ShopPage` | Shopping/product browsing |
| `MenuPage` | Navigation menu |
| `UserProfilePage` / `EditProfilePage` | User profiles |
| `ProfessionalProfilePage` | Contractor-facing profile |
| `PostDetailPage` / `CreatePostPage` | Social post creation |
| `ForumCategoryPage` | Forum/discussion threads |
| `LeaveReviewPage` | Review system |
| `BiometricLockScreen` | Biometric auth |

**Backend:** Firebase (Auth + Firestore + Cloud Storage + App Check + Analytics)  
**UI framework:** Flutter (Material), with Cupertino transitions  
**Login video:** `assets/media/Water_Login.mp4` (37MB!) — animated background  
**Fonts:** Material Icons + Cupertino Icons (no custom brand fonts in assets)

---

## v1 screen gap analysis

Cross-referencing APK screens against the approved v1 flow:

| v1 Required Feature | In APK? | Notes |
|--------------------|---------|-------|
| Pool profile setup (photos + questions) | ❌ No | Not found |
| Gallon estimation flow | ❌ No | Not found |
| Test strip / report intake | ❌ No | Not found |
| Chemical dosing guidance | ❌ No | Not found |
| Order of operations output | ❌ No | Not found |
| Affiliate-linked product recommendations | ❌ No | `ShopPage` exists but appears to be browsing, not recommendations |
| Maintenance report comparison | ❌ No | Not found |
| **Community feed** | ✅ Built | Out of v1 scope |
| **Messaging / group chats** | ✅ Built | Out of v1 scope |
| **Professional profiles / contractor** | ✅ Built | Out of v1 scope |
| **Forum / reviews** | ✅ Built | Out of v1 scope |
| Login / Auth | ✅ Built | Keep |
| Notifications | ✅ Built | Keep |

**Summary: 0 of 7 v1 core features are implemented. 6+ out-of-scope features are.**

---

## Verdict: REBUILD from scratch

### Why not salvage the APK

1. **No source code.** The ZIP contains only a compiled binary. Without the original Flutter project files (`.dart` files, `pubspec.yaml`, etc.), there is nothing to edit, extend, or hand to a developer.

2. **Wrong product was built.** The prototype is a social/marketplace app (community, messaging, forums, contractor profiles). None of the v1 product logic exists.

3. **Decompilation is not viable.** Dart compiles to native machine code in release APKs. Tools like `apktool` can get resource files and manifest, but not readable Dart source.

4. **Single asset worth keeping:** The login video (`Water_Login.mp4`, 37MB) is a polished brand asset. Extract and reuse it.

### What to do about the original developer

The developer has the Flutter source project. Before rebuilding from zero:

1. **Ask the developer directly** for the GitHub repo URL or a source ZIP containing the `.dart` files and `pubspec.yaml`
2. **If they share it:** audit whether the auth/navigation shell is worth adapting
3. **If they don't / can't:** start clean — the rebuild is straightforward given the v1 scope is tighter

### What the rebuild costs

The v1 scope (profile → estimation → intake → plan → recommendations → maintenance check) is a focused, well-defined product. A solo Flutter developer at $30–50/hr could build:

- Pool profile onboarding: ~3 days
- Gallon estimation flow: ~2 days  
- Strip/report/symptom intake: ~2 days
- Recommendation output screen: ~3 days
- Affiliate product screen: ~2 days
- Maintenance comparison: ~3 days
- Auth + nav shell: ~2 days

**Estimated: 3–4 weeks for a working v1 prototype with clean source code**

---

## The one reusable asset

Extract this from the APK for reuse:

```bash
unzip "Pool Vibe/app-release-0.0.1.apk" \
  assets/flutter_assets/assets/media/Water_Login.mp4 \
  -d /home/work/poolvibe-v1/assets/
```

The login background video is polished and matches the PoolVibe water aesthetic. Keep it.

---

## Next steps

1. **GitHub:** Create new repo `angel31700/poolvibe-v1` (token needs refresh — see setup instructions)
2. **Developer ask:** Request Flutter source + `pubspec.yaml` from original developer
3. **Start v1 scaffold:** Flutter project with auth shell + v1 route structure (ready below)
4. **Lock scope:** Any feature not in the v1 flow above requires explicit approval before touching
