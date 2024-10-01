# Todo App

A simple and intuitive Todo application built with Flutter that allows users to manage their tasks efficiently. The app supports adding, editing, deleting tasks, and maintaining their completion status. 

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [App Structure](#app-structure)
- [Contributing](#contributing)
- [License](#license)

## Features

- Add new tasks with titles, descriptions, and due dates.
- Edit existing tasks.
- Delete tasks individually or in bulk.
- Undo task deletion.
- Toggle task completion status.
- Friendly user interface with Snackbar notifications.
- Adaptive theme based on system theme.
- Responsive design.

## Getting Started

To get a local copy of the project up and running, follow these steps.

### Prerequisites

- Flutter SDK
- Dart SDK
- An IDE such as Android Studio or Visual Studio Code

### Installation

1. Clone the repository:

  git clone https://github.com/yourusername/todo_app.git

2. Navigate to the project directory:

  cd todo_app

3. Install dependencies:

  flutter pub get

4.Run the application:

  flutter run

### Usage

1. Open the app on your device or emulator.
2. Click the `+` icon to create a new task.
3. Fill in the task details and click **Add**.
4. View your tasks on the main screen, where you can edit or delete them.
5. Use the app bar menu to delete all or completed tasks.

### Folder Structure

The Project is structured as follows

lib/
├── models/
│   └── task_model.dart        # Task model definition
├── pages/
│   └── taskinput_page.dart    # Page for adding/editing tasks
|   └── todomain_page.dart     # Page displaying list of tasks
├── theme/
│   └── themedata.dart         # Theme Data for light and dark mode
├── widgets/
│   └── taskitem.dart          # Widget for displaying a Task Tile
|   └── tasklist.dart          # Widget for displaying the list of tasks
└── main.dart                  # Entry point of the application

### Application Version

  version: 1.0.0+1

### Flutter Doctor

[√] Flutter (Channel stable, 3.24.2, on Microsoft Windows [Version
    10.0.19045.4894], locale en-US)
    • Flutter version 3.24.2 on channel stable at C:\src\flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 4cf269e36d (4 weeks ago), 2024-09-03   
      14:30:00 -0700
    • Engine revision a6bd3f1de1
    • Dart version 3.5.2
    • DevTools version 2.37.2

[√] Windows Version (Installed version of Windows is version 10 or
    higher)

[√] Android toolchain - develop for Android devices (Android SDK
    version 35.0.0)
    • Android SDK at C:\Users\e2maa\AppData\Local\Android\sdk
    • Platform android-35, build-tools 35.0.0
    • Java binary at: C:\Program Files\Android\Android       
      Studio\jbr\bin\java
    • Java version OpenJDK Runtime Environment (build        
      17.0.11+0--11852314)
    • All Android licenses accepted.

[√] Chrome - develop for the web
    • Chrome at C:\Program
      Files\Google\Chrome\Application\chrome.exe

[√] Visual Studio - develop Windows apps (Visual Studio Community
    2022 17.10.1)
    • Visual Studio at C:\Program Files\Microsoft Visual  
      Studio\2022\Community
    • Visual Studio Community 2022 version 17.10.34928.147
    • Windows 10 SDK version 10.0.22621.0

[√] Android Studio (version 2024.1)
    • Android Studio at C:\Program Files\Android\Android Studio
    • Flutter plugin can be installed from:
       https://plugins.jetbrains.com/plugin/9212-flutter       
    • Dart plugin can be installed from:
       https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build
      17.0.11+0--11852314)

[√] VS Code (version 1.93.1)
    • VS Code at C:\Users\e2maa\AppData\Local\Programs\Microsoft VS 
      Code
    • Flutter extension version 3.96.0

[√] Connected device (4 available)
    • sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64    
      • Android 15 (API 35) (emulator)
    • Windows (desktop)            • windows       • windows-x64    
      • Microsoft Windows [Version 10.0.19045.4894]
    • Chrome (web)                 • chrome        • web-javascript 
      • Google Chrome 129.0.6668.60
    • Edge (web)                   • edge          • web-javascript 
      • Microsoft Edge 128.0.2739.79

[√] Network resources
    • All expected network resources are available.

• No issues found!