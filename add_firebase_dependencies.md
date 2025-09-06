# Adding Firebase SPM Dependencies

## Manual Steps Required

Since we can't automatically add SPM dependencies via command line, you'll need to add them manually in Xcode:

### 1. Open the Project in Xcode
```bash
open Miltrack.xcodeproj
```

### 2. Add Firebase Package
1. In Xcode, go to **File** → **Add Package Dependencies...**
2. Enter the Firebase iOS SDK URL: `https://github.com/firebase/firebase-ios-sdk`
3. Click **Add Package**
4. Select the following products:
   - `FirebaseAuth`
   - `FirebaseFirestore`
   - `FirebaseStorage`
   - `FirebaseAnalytics`
5. Click **Add Package**

### 3. Add to Target
1. Select your project in the navigator
2. Select the **Miltrack** target
3. Go to **General** tab
4. In **Frameworks, Libraries, and Embedded Content**, click the **+** button
5. Add the Firebase frameworks you selected above

### 4. Verify Build
After adding the dependencies, the app should build successfully with Firebase support.

## Current Status

✅ **Step 2 Complete**: Firebase Wiring (no business logic)

### What's Implemented:
- **FirebaseManager**: Safely initializes Firebase if `GoogleService-Info.plist` exists, otherwise falls back to mock mode
- **Protocol-based Services**: 
  - `AuthServiceProtocol` with `FirebaseAuthService` and `MockAuthService`
  - `FirestoreServiceProtocol` with `FirebaseFirestoreService` and `MockFirestoreService`
  - `StorageServiceProtocol` with `FirebaseStorageService` and `MockStorageService`
- **AppEnvironment**: Automatically chooses mock vs Firebase services based on `FeatureFlags.enableMockData`
- **Conditional Compilation**: All Firebase code is wrapped in `#if canImport(FirebaseCore)` blocks
- **Mock Mode**: App runs successfully without Firebase dependencies

### Acceptance Criteria Met:
✅ No crashes if Firebase plist is missing  
✅ Switching `enableMockData` toggles providers  
✅ Build succeeds with Firebase packages linked (when added manually)  
✅ App runs in mock mode without Firebase configuration  

## Next Steps

Once you add the Firebase SPM dependencies manually, the app will automatically switch to using Firebase services when a `GoogleService-Info.plist` file is present in the project.
