# 🛡️ QuakeCare - Earthquake Preparedness and Coordination Mobile Application

<p align="center">
  <img src="https://github.com/user-attachments/assets/4c4aa1cb-a974-4ccb-96c1-a44a3ad2fdff" alt="QuakeCare Logo" width="150" />
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-v3.5+-02569B?logo=flutter&logoColor=white" alt="Flutter Badge"/></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-v3.5+-0175C2?logo=dart&logoColor=white" alt="Dart Badge"/></a>
  <a href="#"><img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green" alt="Platform Badge"/></a>
  <a href="#"><img src="https://img.shields.io/badge/License-MIT-blue" alt="License"/></a>
</p>

---

## 📌 What is QuakeCare?

**QuakeCare** is a modern and comprehensive mobile application designed to help you prepare before an earthquake, execute the correct survival steps during an earthquake without panicking, and stay safe by ensuring seamless post-earthquake coordination.

Developed with Flutter, this app aims to be your ultimate assistant during natural disasters with its user-friendly interface, native local notification support, voice-guided drill guide, interactive map modules, and emergency planning tools.

---

## 🚀 Key Features

The application offers **6 core modules** to simplify earthquake preparedness and emergency management:

### 1. 🏫 Earthquake Drill Guide (Voice-Guided & Manageable)
* **Step-by-Step Guidance:** Displays crucial actions to take during an earthquake (e.g., Drop-Cover-Hold On) in a chronological sequence.
* **Voice Navigation (TTS):** Utilizes Turkish Text-to-Speech technology to read drill steps aloud, allowing you to practice without looking at your screen.
* **Customizable Steps:** Add, delete, or reorder drill steps easily using drag-and-drop.
* **Scheduled Notifications:** Set up drill reminders for future dates to keep your safety readiness up to date.

### 2. 🗺️ Safe Zone Recommendation
* **Interactive Map:** Displays your live location and nearby assembly areas using OpenStreetMap infrastructure via `flutter_map`.
* **Smart Distance Analysis:** Automatically calculates the nearest assembly area based on your current GPS coordinates and highlights it in green on the map.

### 3. 🚨 User Status Sharing
* **Status Reporting:** Select your post-earthquake status from options like "I'm Safe", "I Need Help", or "Emergency Assistance Required!".
* **Social Map Dashboard:** View the real-time status and location of other users on the map with color-coded markers (Red: Emergency, Orange: Needs Help, Green: Safe).

### 4. 🎒 Earthquake Bug-Out Bag (Checklist)
* **Essential Requirements:** Built-in checklist featuring critical items such as water, canned food, first-aid kits, and flashlights.
* **Personalization:** Add custom items to your bag, or update and delete existing ones.
* **Data Persistence:** Your selections are stored securely on the device storage using `SharedPreferences`.

### 5. 📞 Emergency Contacts (Quick Dial)
* **Contact Management:** Save names and phone numbers of people to reach during an emergency.
* **Quick Dial & Copy:** Call contacts with a single tap using `url_launcher` or copy their numbers to the clipboard.

### 6. ⚠️ Recent Earthquakes
* **Real-time Data:** Fetches and displays recent earthquakes in and around Turkey using the USGS (United States Geological Survey) API.
* **Earthquake Details:** Presents magnitude, location, date, time, and depth information in clean card layouts.

---

## 📲 Download APK

You can download the latest stable release APK to install the application directly on your Android devices:

> [!IMPORTANT]
> **[📥 Download QuakeCare APK File (v1.0.0)](#)** *(You may need to allow installations from unknown sources in your device settings after downloading the file.)*

*(Note: You can replace this placeholder with your own APK download link or GitHub Release URL.)*

---

## 📸 Screenshots

<div align="center">

| Home Page | Drill Guide | Recent Earthquakes |
| :---: | :---: | :---: |
| <p align="center"><img src="https://github.com/user-attachments/assets/e308dc58-1637-41a7-a04b-210b26665d42" alt="Home Page" width="220"/></p> | <p align="center"><img src="https://github.com/user-attachments/assets/90cf2eb9-174c-4a18-a1c1-5b38fc6a8035" alt="Drill Guide" width="220"/></p> | <p align="center"><img src="https://github.com/user-attachments/assets/002a67f0-f58d-40ad-81f6-65e27efad03f" alt="Recent Earthquakes" width="220"/></p> |

| User Status | Emergency Guide | Earthquake Kit |
| :---: | :---: | :---: |
| <p align="center"><img src="https://github.com/user-attachments/assets/33d52c99-af11-4f7d-b731-f8bfe4d7cd62" alt="User Status" width="220"/></p> | <p align="center"><img src="https://github.com/user-attachments/assets/cfb39f58-6102-49e3-b05a-f7a041640dc7" alt="Emergency Guide" width="220"/></p> | <p align="center"><img src="https://github.com/user-attachments/assets/31500472-321c-4f4c-bd3a-0484232006b6" alt="Earthquake Kit" width="220"/></p> |

</div>

---

## 🛠️ Technologies and Packages Used

* **Flutter & Dart SDK** - Cross-platform mobile application framework.
* **Provider** - State Management.
* **Flutter Map (OpenStreetMap) & Latlong2** - Interactive map rendering and coordinate/distance calculations.
* **Flutter TTS (Text-to-Speech)** - Native text-to-speech integration for audible drill steps.
* **Flutter Local Notifications** - Local device notifications for drill reminders.
* **Shared Preferences** - Persistent local storage for the emergency bag checklist and contact information.
* **Geolocator & Geocoding** - Live GPS location tracking and coordinate geoprocessing.
* **HTTP** - Network requests to fetch the latest seismic data from the USGS API.
* **URL Launcher** - Integration to trigger native phone dialer directly for emergency contacts.

---

## 📂 Project Directory Structure

```text
lib/
├── main.dart                  # Application entry point and service initializations
├── providers/
│   └── drill_provider.dart    # State management for drills, TTS, notifications, and SharedPreferences
├── screens/
│   ├── contact_screen.dart    # Emergency Contacts (Add, Delete, Call, Copy)
│   ├── drill_screen.dart      # Drill creation and management dashboard
│   ├── emergency_kit_screen.dart # Earthquake Bag checklist interface
│   ├── guide_screen.dart      # Step-by-step active drill guide interface
│   ├── home_screen.dart       # Main menu grid dashboard and routing navigation
│   ├── recent_earthquakes_screen.dart # Real-time recent earthquakes list via USGS API
│   ├── safe_zone_screen.dart  # Map view displaying recommended safe assembly zones
│   └── user_status_screen.dart # Interactive status reporting map panel for users
├── services/
│   ├── location_service.dart  # GPS location acquisition and distance tracking algorithms
│   └── notification_service.dart # Local notification service configurations and triggers
└── widgets/
    ├── drill_timer_widget.dart # Visual progress tracking countdown timer component
    └── safe_zone_widget.dart  # Information card overlay for map safe zones

```

---

## ⚙️ Installation and Setup

Follow these steps to clone and run the project locally on your machine:

### Prerequisites
* Ensure you have Flutter SDK installed (Recommended: v3.5.0 or higher).
* An active Android/iOS emulator or a connected physical testing device.

### Steps

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/UGURGULAYDIN/QuakeCare-Earthquake-Mobile-App.git
   cd QuakeCare-Earthquake-Mobile-App
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the Application:**
   ```bash
   flutter run
   ```

4. **Build Release APK (Android):**
   ```bash
   flutter build apk --release
   ```
   *The generated production-ready APK binary will be located at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📬 Contact

Feel free to reach out to me for any questions, feedback, or collaboration opportunities regarding the project:

<table>
  <tr style="border: none; background: none;">
    <td width="100" style="border: none; background: none; padding: 0; margin: 0;">
      <a href="http://www.linkedin.com/in/u%C4%9Fur-g%C3%BClaydin-9053902b6" target="_blank">
        <img src="https://images.weserv.nl/?url=https%3A%2F%2Fmedia.licdn.com%2Fdms%2Fimage%2Fv2%2FD4D03AQGCopOawLDLxg%2Fprofile-displayphoto-scale_200_200%2FB4DZ769vlgGkAc-%2F0%2F1782326951936%3Fe%3D2147483647%26v%3Dbeta%26t%3DLY9VRQ1CkZRQ1x8AbcwHM-AutqHQzwCmlV5yjPSH8Ho&w=100&h=100&fit=cover&mask=circle" width="100" height="100" alt="Uğur Gülaydın" style="display: block; border: none;" />
      </a>
    </td>
    <td style="border: none; background: none; padding-left: 20px; vertical-align: middle;">
      <strong style="font-size: 20px;">UĞUR GÜLAYDIN</strong><br />
      For instant communication and networking:<br />
      👉 <a href="http://www.linkedin.com/in/u%C4%9Fur-g%C3%BClaydin-9053902b6" target="_blank" style="text-decoration: none; font-weight: bold;">Connect on LinkedIn</a>
    </td>
  </tr>
</table>

## 📄 License

This project is licensed under the [MIT License](LICENSE).
