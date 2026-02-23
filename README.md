# Drop in Locker — Flutter App

A production-ready Flutter application for smart modular locker management. Built with the teal/white brand identity, offline-first architecture, and 3D locker visualization.

---

## 🚀 Quick Setup

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0
- Android Studio / Xcode (for device deployment)

### Install & Run
```bash
cd drop_in_locker
flutter pub get
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart                     # Entry point, Provider setup
├── theme/
│   └── app_theme.dart            # Colors, typography, ThemeData
├── models/
│   └── locker_model.dart         # Data models & sample data
├── services/
│   └── app_state.dart            # ChangeNotifier state management
├── widgets/
│   ├── common_widgets.dart       # StatCard, AppCard, Badge, etc.
│   └── locker_3d_widget.dart     # CustomPainter 3D locker + CompartmentDetail
└── screens/
    ├── onboarding_screen.dart    # 3-step Q&A onboarding flow
    ├── main_shell.dart           # Bottom nav shell
    ├── dashboard_screen.dart     # Main dashboard
    ├── locker_view_screen.dart   # Interactive 3D locker management
    ├── reserve_screen.dart       # AI assignment + reserve flow
    ├── logs_screen.dart          # Access log audit trail
    └── profile_screen.dart       # User profile & settings
```

---

## 🎯 Features Implemented

### Onboarding (3-Step Q&A Flow)
- **Step 1**: Storage type selection (Drop-in / Package / Cooled / Clothes)
- **Step 2**: Size selection (S/M/L) with AI recommendation card
- **Step 3**: Confirmation with access method display (App / NFC / PIN)

### Dashboard
- Real-time utilization stats (87% → target 90%)
- WebSocket connection status indicator
- My Active Locker card with unlock/lock toggle
- Utilization breakdown by locker size
- Cooled section temperature gauge (12°C–16°C HVAC range)
- Access log feed with timestamps

### 3D Locker View
- Interactive `CustomPainter`-based isometric 3D model
- Drag-to-rotate gesture (horizontal swipe)
- Auto-rotation animation (subtle floating effect)
- Tap compartments to inspect: status, type, size, temperature
- Reserve available lockers directly from the 3D view
- Zone filter bar and compartment list

### Reserve Screen
- Storage type picker with animated selection states
- Size override (S/M/L) — user retains full control over AI recommendation
- Assignment criteria: Proximity vs. Temperature optimization
- Simulated AI decision tree (<200ms, shows actual elapsed time)
- Confirm or Override the AI assignment

### Access Logs
- Full audit trail with method filtering (All / App / NFC / PIN)
- AES-256 security status banner with on-premises data sovereignty badge
- Token revocation time display
- Stats: total events, NFC count, PIN fallbacks

### Profile & Settings
- User card with membership tier
- NFC AES-256 Challenge-Response toggle
- PIN Fallback (offline mode) toggle
- Token revocation status (<5s SLA)
- Data sovereignty region (Saudi Arabia)
- WebSocket sync status
- HVAC sensor monitoring status
- Hardware Control Unit firmware status

---

## 🏗️ Technical Architecture

### State Management
`Provider` + `ChangeNotifier` via `AppState`:
- Onboarding completion tracking
- Selected compartment and locker status
- WebSocket connection state
- AI assignment simulation
- Temperature readings

### Rendering
- `CustomPainter` for the interactive 3D isometric locker structure
- `AnimationController` for smooth auto-rotation
- `GestureDetector` for drag-to-rotate interaction
- `AnimatedContainer` for selection state transitions

### Security (Production Integration Points)
- AES-256 NFC token exchange → integrate `nfc_manager` package
- WebSocket real-time hardware sync → `web_socket_channel`
- Secure token storage → `flutter_secure_storage`
- Challenge-Response protocol → implement in `services/nfc_service.dart`

### Backend Integration
Connect to your NodeJS + Express backend:
```dart
// In services/websocket_service.dart
final channel = WebSocketChannel.connect(
  Uri.parse('wss://your-backend-sa.example.com/ws'),
);
```

### Hardware Commands
The backend sends commands to the C Control Unit:
```
App → WebSocket → NodeJS → MongoDB (log) → C Control Unit → Motorized Latch
```

---

## 📦 Key Dependencies

| Package | Purpose |
|---|---|
| `provider` | State management |
| `google_fonts` | Syne + DM Sans typography |
| `flutter_animate` | Page/widget animations |
| `nfc_manager` | NFC tag read/write |
| `web_socket_channel` | Hardware real-time sync |
| `flutter_secure_storage` | Token storage |
| `intl` | Date/time formatting |

---

## 🎨 Design System

**Colors**
- Primary: `#00BFA5` (Teal)
- Dark: `#1A2A2A` (Slate)
- Background: `#F4FAFA` (Off-white)

**Typography**
- Display/Headings: **Syne ExtraBold**
- Body/Labels: **DM Sans**

---

## 🔜 Next Steps

1. Add `google_fonts` asset bundling for offline font support
2. Implement real WebSocket connection to NodeJS backend
3. Wire up `nfc_manager` for live NFC challenge-response
4. Add `flutter_secure_storage` for token persistence
5. Replace `SampleData` with live API calls
6. Add `three_dart` or `flutter_gl` for fully 3D rendered locker model
7. Implement push notifications for access alerts
8. Add biometric authentication (`local_auth` package)
