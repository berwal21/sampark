# Sampark - Chat Application

Sampark is a real-time chat application built using Flutter, Dart, Firebase Authentication, and Firestore. It allows users to communicate seamlessly, supporting features like user authentication, direct messaging, and instant updates.

## Features

- **User Authentication:** Secure sign-up and sign-in using Firebase Authentication.
- **Real-Time Messaging:** Instantly send and receive messages using Firestore.
- **User List:** View and chat with registered users.
- **Message Threads:** Organized conversations with individual users.
- **Responsive UI:** Clean, modern, and mobile-friendly Flutter interface.

## Screenshots

![sm1](https://github.com/user-attachments/assets/0a4291cf-e3b9-41f2-b4db-5650c4bfe4ea)
![sm2](https://github.com/user-attachments/assets/1ef42e5f-31f8-4698-ba53-3228372a7733)
![sm3](https://github.com/user-attachments/assets/f7d473f9-3eec-4e78-b760-2d23a8208e4c)
![sm4](https://github.com/user-attachments/assets/ca7f5ba2-da71-43d1-80c0-7111b7f8dd15)
![sm5](https://github.com/user-attachments/assets/c0e24a0f-634e-4074-bb64-91b5beeeb1fb)


## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Firebase Account](https://firebase.google.com/)
- [Firestore Database](https://firebase.google.com/products/firestore)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/sampark.git
   cd sampark
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Enable **Authentication** and **Firestore Database**.
   - Download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) and place them in your project as per FlutterFire documentation.

4. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
  ├── main.dart
  ├── screens/
  │     ├── login_screen.dart
  │     ├── chat_screen.dart
  │     └── user_list_screen.dart
  ├── models/
  │     └── user_model.dart
  ├── services/
  │     ├── auth_service.dart
  │     └── chat_service.dart
  └── widgets/
        ├── message_bubble.dart
        └── user_tile.dart
```

## Configuration

- Update your Firebase project configuration in `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`.
- Make sure to enable required authentication providers (email/password, etc.) in Firebase Console.

## Dependencies

- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `flutter`

Add these in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest
  provider: ^latest
```

**Sampark** – Connecting people, one message at a time!
