# Things To Do for LifeMix App

### **1. Authentication & APIs**
- Obtain **Google Sign-In OAuth client ID** for Android & iOS.  
- Configure **Google API keys** for any additional Google services (e.g., Calendar, Drive).  
- Implement **server-side token management** if required for extended Google API usage.

### **2. Firebase Setup**
- Create Firebase project & add **Android/iOS apps**.  
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).  
- Enable **Firebase Authentication** and **Firestore/Realtime DB** if needed.  
- Add Firebase **API keys** to app configuration.  

### **3. Notifications**
- Configure **Android Notification Channel** properly in `AndroidManifest.xml`.  
- Verify **iOS notification permissions** and capabilities in Xcode.  
- Test **daily habit reminders** and optional **event notifications**.

### **4. UI Enhancements**
- Theme switching (light/dark) complete ✅ (already implemented).  
- Habit **streak tracking** complete ✅ (already implemented).  
- **Calendar view** complete ✅ (already implemented).  

### **5. App Deployment**
- Test **APK build** locally using `flutter build apk --release`.  
- Prepare **app icons** and splash screens.  
- Test **iOS build** if targeting Apple devices.  
- Set up **Play Store / App Store listings** if publishing.  

### **6. Optional Features**
- Enable **push notifications** for habit streak milestones.  
- Add **analytics** to track user engagement.  
- Implement **backup/restore** using Firebase or local storage.  
