# StudyMate – Smart Study Planner

StudyMate is a Flutter-based mobile application designed to help students organize their academic tasks in one place. It provides a simple dashboard for viewing study tasks, adding new tasks, tracking completion, and keeping task data synchronized with Firebase Cloud Firestore. The student's display name is stored locally using SharedPreferences.

> **Project status:** The release APK has been built, installed on an Android device, and manually tested successfully.

## Contents

- [Project overview](#project-overview)
- [Main features](#main-features)
- [Technology stack](#technology-stack)
- [Application structure](#application-structure)
- [How data is stored](#how-data-is-stored)
- [Firebase setup](#firebase-setup)
- [Run the project locally](#run-the-project-locally)
- [Build the APK](#build-the-apk)
- [Testing](#testing)
- [Download the APK](#download-the-apk)
- [Security notes](#security-notes)
- [Limitations and future improvements](#limitations-and-future-improvements)

## Project overview

Students often need to remember assignments, revision tasks, and upcoming study activities. StudyMate provides a single place to record and monitor these tasks. The application is developed with Flutter and Dart. Firebase Cloud Firestore is used for cloud-based task storage, while SharedPreferences stores the student's name on the device.

## Main features

1. **Welcome screen:** Introduces the application and provides navigation to the dashboard.
2. **Study dashboard:** Displays study tasks and an overview of study progress.
3. **Add study task:** Allows a student to enter a task title, subject, due date, and optional notes.
4. **Task completion:** Allows a task to be marked as completed or incomplete.
5. **Delete task:** Allows a task to be removed.
6. **Cloud task storage:** Saves and retrieves tasks from the Firestore `study_tasks` collection.
7. **Local name storage:** Saves the student's display name using SharedPreferences so it remains available after the app is reopened.
8. **Live task updates:** The dashboard listens to Firestore task updates and refreshes when the collection changes.
9. **Basic error handling:** Displays an error state when task data cannot be loaded.

## Technology stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile application framework |
| Dart | Application programming language |
| Material Design | User interface components and styling |
| Firebase Core | Initializes Firebase in the Flutter application |
| Cloud Firestore | Cloud database for study tasks |
| SharedPreferences | Local storage for the student's name |
| Git and GitHub | Source-code version control and hosting |
| GitHub Actions | Automated Android release APK build |

## Application structure

The main application code is organized under `lib/`:

```text
studymate/
├── android/
│   └── app/
│       └── google-services.json       # If used by Android Firebase Gradle setup
├── lib/
│   ├── main.dart                      # App entry point and Firebase initialization
│   ├── firebase_options.dart          # FlutterFire platform configuration
│   ├── models/
│   │   └── study_task.dart            # StudyTask model and map conversion
│   ├── screens/
│   │   ├── splash_screen.dart         # Welcome screen
│   │   ├── home_screen.dart           # Dashboard and task list
│   │   ├── add_task_screen.dart       # Add-task form
│   │   └── task_details_screen.dart   # Task details screen, if included
│   ├── services/
│   │   └── firestore_service.dart     # Firestore CRUD operations
│   └── widgets/
│       └── task_card.dart             # Reusable task UI, if used
├── .github/
│   └── workflows/
│       └── build-apk.yml              # GitHub Actions APK workflow
├── pubspec.yaml                       # Dependencies and project metadata
├── pubspec.lock                       # Locked dependency versions
└── README.md
```

The exact set of optional screen/widget files may differ depending on the final project version. Keep this tree aligned with the files actually present in the GitHub repository.

## How data is stored

### Cloud storage – Firebase Cloud Firestore

Study tasks are stored in the Firestore collection:

```text
study_tasks
```

Each task document contains fields similar to:

```json
{
  "title": "Revise Data Structures",
  "subject": "Computer Science",
  "dueDate": "2026-11-15T00:00:00.000",
  "notes": "Revise linked lists and trees",
  "isCompleted": false
}
```

Firestore document IDs are used as task IDs in the application. The application performs the following operations:

- **Create:** Adds a new task document.
- **Read:** Listens to the collection and displays the retrieved tasks.
- **Update:** Updates the task completion status.
- **Delete:** Deletes the selected task document.

### Local storage – SharedPreferences

SharedPreferences stores the student's display name on the device. This is a small local preference and is separate from the cloud task collection. The name remains saved when the app is closed and reopened on the same device, unless app data is cleared or the app is uninstalled.

## Firebase setup

To run your own copy of StudyMate:

1. Create or select a Firebase project in the Firebase Console.
2. Register the Android application using the Android application ID configured in the project. In this project it is `com.example.studymate`, unless you have changed it.
3. Configure Firebase for Flutter using the FlutterFire CLI.
4. Generate the platform configuration file `lib/firebase_options.dart`.
5. Enable Cloud Firestore in the Firebase Console.
6. If the Android Gradle configuration applies the Google Services plugin, add the matching `android/app/google-services.json` file.
7. Review Firestore Security Rules before using the app with real users.

**Security warning:** A development rule such as `allow read, write: if true;` permits anyone who can reach the database to read and write matching documents. It is not suitable for a public production app. For production, add Firebase Authentication and user-specific Firestore rules so each user can access only their own tasks. Do not put Firebase Admin service-account keys or private signing credentials in the repository.

## Run the project locally

### Requirements

- Flutter SDK (the project was developed using Flutter 3.47.9 stable)
- Dart SDK compatible with the Flutter version
- Android Studio / Android SDK
- VS Code or another Flutter-compatible editor
- A configured Firebase project

### Commands

Open a terminal in the project root and run:

```bash
flutter doctor
flutter pub get
flutter run
```

To run on a specific connected device, first check available devices:

```bash
flutter devices
```

Then run:

```bash
flutter run -d <device-id>
```

## Build the APK

To build a release APK locally:

```bash
flutter build apk --release
```

The generated APK is normally located at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

This project also includes a GitHub Actions workflow at `.github/workflows/build-apk.yml`. The workflow checks out the repository, configures Java and Flutter, installs dependencies, builds the release APK, and uploads it as an artifact.

### Download from GitHub Actions

1. Open the repository on GitHub.
2. Select **Actions**.
3. Open a successful **Build StudyMate Release APK** run.
4. Find the **Artifacts** section near the bottom of the run page.
5. Download `StudyMate-Release-APK` and extract the ZIP file.
6. Install `app-release.apk` on a compatible Android device.

## Testing

The following manual tests were completed on the release APK:

| Test case | Expected result | Result |
|---|---|---|
| Launch application | Welcome screen opens | Passed |
| Open dashboard | Dashboard and tasks load | Passed |
| Save student name | Name remains after reopening app | Passed |
| Add a task | Task appears on dashboard and in Firestore | Passed |
| Mark task complete | Completion status changes and is saved | Passed |
| Delete a task | Task disappears from app and Firestore | Passed |
| Reopen application | Previously saved tasks load again | Passed |
| Install and run release APK | APK installs and application works | Passed |

These are manual application tests; they should not be described as automated unit/widget test results.

## Download the APK

The release APK is available from the successful GitHub Actions workflow artifact. After downloading and extracting the artifact, use `app-release.apk`.

If you are distributing the APK outside the course submission, share it only with people who understand that this is a student project and that the Firebase database rules must be secured before public use.


## Author / course information

Update this section before submission if your instructor requires it:

- **Project:** StudyMate – Smart Study Planner
- **Subject:** Flutter App Development
- **Student name:** Maryam Shaikh
- **Batch / institute:**  Batch-3 - Hunarmand Punjab
- **Repository:** (https://github.com/MaryamShaikh124/studymate)
