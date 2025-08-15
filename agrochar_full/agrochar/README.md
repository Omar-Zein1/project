# AgroChar (Flutter + Firebase)

Bilingual (Arabic/English) marketplace connecting farmers and factories to trade agricultural by‑products, with support for partial fulfillment of offers.

## Features
- Web + Android + iOS from one Flutter codebase.
- Auth: email/password (ready) + phone OTP (code included; requires Firebase setup).
- Offers (Sell/Buy), Requests, Add Offer (single page for buy/sell).
- Partial fulfillment: reserve a quantity and remaining updates automatically.
- Arabic (Fusha) / English toggle in-app.
- Simple splash screen.

## Quick Start
1. **Install Flutter** and **Dart**.
2. Create a Firebase project and enable:
   - Authentication: Email/Password, Phone
   - Firestore (Native mode)
3. Add platforms:
   - Android: download `google-services.json`
   - iOS: download `GoogleService-Info.plist`
   - Web: copy Firebase config values
4. Generate `lib/firebase_options.dart` via `flutterfire` CLI:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   This will create `lib/firebase_options.dart` automatically.
5. Run the app:
   ```bash
   flutter pub get
   flutter run -d chrome      # Web
   flutter run -d android     # Android
   flutter run -d ios         # iOS (on macOS)
   ```

## Switch between Mock & Firebase Data
The app uses a repository pattern. By default it runs **MockRepository** with seeded demo data.
To use Firestore, open `lib/services/repository_provider.dart` and set `useFirebase = true` after you finish Firebase setup.

## Deploy Web Demo
```bash
flutter build web
# Option A: Firebase Hosting
npm i -g firebase-tools
firebase login
firebase init hosting
# choose build/web as public; SPA yes
firebase deploy
```

## Notes on Phone Auth (OTP)
Phone auth on the web requires domain whitelisting and reCAPTCHA. On Android/iOS you must add SHA-1 (Android) and proper capabilities (iOS). The code is provided; follow Firebase docs if you face prompts.

---

Made for: **AgroChar**
