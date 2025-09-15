# OCR Scanner App

A Flutter mobile application that uses camera-based OCR (Optical Character Recognition) to extract numbers from images. The app provides a live camera preview with an overlay guide, captures images, processes them to extract numeric content, and stores the results with a complete history management system.

## Features

### Enhanced Camera Integration
- Live camera preview with animated rectangle overlay guide
- Optimized rectangular frame (85% width, 30% height) for better number scanning
- Animated semi-transparent mask with gradient borders and pulse effects
- Enhanced capture button with haptic feedback and smooth animations
- Comprehensive camera permissions handling with guided user flow
- Graceful handling of all permission states (granted, denied, permanently denied)
- App lifecycle management with automatic permission re-checking
- Refresh functionality for users returning from device settings

### Advanced Image Processing & OCR
- Crops captured images to exact rectangle bounds in pixels with precise coordinate mapping
- OCR functionality to extract digits (0-9) from cropped images using Google ML Kit
- Handles number formats including decimals (e.g., 123.45)
- Returns extracted numbers as array of strings in reading order (top-to-bottom, left-to-right)
- Filters out non-numeric content from OCR results using regex patterns
- **Always saves cropped images** regardless of OCR success for complete scan history

### Enhanced Data Management & UI
- Stores scan results with unique ID, timestamp, and extracted numbers array
- Saves cropped image thumbnails for preview (always saved, even with no OCR results)
- Modern, card-based history list screen with gradient icons and improved typography
- Comprehensive detail screen with enhanced visual design and copy functionality
- Beautiful empty states with call-to-action buttons
- Improved error handling with user-friendly messages and retry options
- Bulk operations (clear all scans) with confirmation dialogs

### Premium User Experience
- Intuitive camera permission flow with educational messaging
- Comprehensive failure scenario handling with guided recovery options
- Optimized app performance with smooth 60fps animations
- Modern Material Design 3 inspired UI with gradient effects
- Haptic feedback for better interaction feel
- Enhanced copy-to-clipboard functionality with visual confirmation
- Floating snackbars with action buttons for improved UX
- App lifecycle management for seamless camera transitions

## Technical Implementation

### Libraries Used

1. **camera: ^0.10.5+9** - Camera functionality and live preview
2. **permission_handler: ^11.3.1** - Runtime permission management
3. **google_mlkit_text_recognition: ^0.13.0** - OCR text recognition
4. **path_provider: ^2.1.3** - File system path management
5. **sqflite: ^2.3.3+1** - Local SQLite database storage
6. **image: ^4.1.7** - Image processing and cropping
7. **path: ^1.8.3** - Path manipulation utilities

### Architecture

The app follows a clean architecture pattern with separation of concerns:

- **Models**: Data structures for scan results
- **Services**: Business logic for OCR processing and database operations
- **Screens**: UI components for different app screens
- **Widgets**: Reusable UI components like camera overlay

### Rectangle-to-Image Coordinate Mapping

The app uses a fixed rectangle overlay that represents 85% of screen width and 30% of screen height, centered on the screen. The coordinate mapping logic:

1. **Screen Coordinates**: Rectangle position calculated as percentages of screen dimensions
2. **Image Coordinates**: Converted to pixel coordinates based on captured image dimensions
3. **Cropping**: Uses relative coordinates (0.0-1.0) that are then mapped to actual pixel values
4. **Bounds Checking**: Ensures crop coordinates stay within image boundaries

```dart
// Rectangle dimensions as percentages
const double rectWidth = 0.85;  // 85% of screen width
const double rectHeight = 0.30; // 30% of screen height
const double rectX = (1.0 - rectWidth) / 2;   // Centered horizontally
const double rectY = (1.0 - rectHeight) / 2;  // Centered vertically

// Convert to pixel coordinates
int x = (cropX * image.width).round();
int y = (cropY * image.height).round();
int width = (cropWidth * image.width).round();
int height = (cropHeight * image.height).round();
```

### OCR Implementation

The OCR implementation uses Google ML Kit's text recognition:

1. **Text Recognition**: Processes the cropped image to extract all text
2. **Text Block Sorting**: Sorts detected text blocks by position (top-to-bottom, left-to-right)
3. **Number Extraction**: Uses regex pattern `\d+\.?\d*` to extract numbers including decimals
4. **Result Filtering**: Filters out non-numeric content and empty matches

### Database Schema

SQLite database with a single table for scan results:

```sql
CREATE TABLE scan_results(
  id TEXT PRIMARY KEY,
  timestamp INTEGER NOT NULL,
  extractedNumbers TEXT NOT NULL,  -- Comma-separated string
  imagePath TEXT
)
```

## Setup Instructions

### Prerequisites
- Flutter SDK (>=3.4.0)
- Android Studio / Xcode for device deployment
- Physical device (camera functionality requires real device)

### Android Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ocr
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Android permissions** (already configured in `android/app/src/main/AndroidManifest.xml`):
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   ```

4. **Run on Android device**
   ```bash
   flutter run
   ```

### iOS Setup

1. **iOS permissions** (already configured in `ios/Runner/Info.plist`):
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access to scan numbers from images</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>This app needs photo library access to save scanned images</string>
   ```

2. **Run on iOS device**
   ```bash
   flutter run
   ```

### Build for Release

**Android APK:**
```bash
flutter build apk --release
```

**iOS IPA:**
```bash
flutter build ios --release
```

## Known Limitations

1. **OCR Accuracy**: Recognition accuracy depends on image quality, lighting conditions, and text clarity
2. **Number Format Support**: Currently optimized for standard numeric formats; may have issues with unusual number representations
3. **Language Support**: Optimized for English numeric characters
4. **Performance**: OCR processing time varies based on image complexity and device performance
5. **Storage**: Cropped images are stored locally and may accumulate over time
6. **Camera Resolution**: Fixed to high resolution which may impact performance on older devices

## Potential Improvements

1. **Enhanced OCR**: 
   - Support for more number formats and currencies
   - Confidence scoring for extracted numbers
   - Multiple OCR engine fallbacks

2. **User Experience**:
   - Manual crop adjustment interface
   - Batch processing of multiple images
   - Export functionality (CSV, JSON)
   - Cloud backup and sync

3. **Performance**:
   - Background processing for OCR
   - Image compression optimization
   - Caching mechanisms

4. **Features**:
   - Text-to-speech for extracted numbers
   - Calculator integration
   - Custom rectangle size adjustment
   - Multiple language support
