# otp_verify

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## To Connect firebase projects with other projects ##

1:Reuse the same authentication code.
2:Firebase Configuration:Register each app with same firebase project.
3:
lib/
 ├── main.dart
 ├── firebase_options.dart
 └── app/
     └── modules/
         └── auth/
             ├── views/
             │   ├── login_view.dart
             │   └── otp_view.dart
             ├── controllers/
             │   └── auth_controller.dart
             └── services/
                 └── auth_service.dart

copy and paste the above fields project in to the existing project.
