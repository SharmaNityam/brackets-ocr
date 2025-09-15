# OCR Scanner App Demo Script

## Demo Flow (30-90 seconds)

### 1. App Launch & Camera Interface (10-15 seconds)
- **Action**: Launch the app
- **Show**: 
  - Camera permission request dialog (if first time)
  - Live camera preview with overlay rectangle guide
  - Semi-transparent mask outside rectangle area
  - Corner indicators on rectangle
  - Capture button at bottom
  - Instructions text at top

### 2. Number Capture Process (15-20 seconds)
- **Action**: Position a document/receipt with numbers within the rectangle
- **Show**:
  - Numbers clearly visible within the rectangle guide
  - Tap the capture button
  - Processing indicator (spinning circle on capture button)
  - Success snackbar showing "Found X numbers: 123, 456, 789..."

### 3. History Screen Navigation (10-15 seconds)
- **Action**: Tap the history icon in the app bar
- **Show**:
  - History screen with list of previous scans
  - Each item showing:
    - Number count badge
    - First few extracted numbers
    - Timestamp (e.g., "2 minutes ago")
  - Pull-to-refresh functionality

### 4. Detail Screen View (15-20 seconds)
- **Action**: Tap on a scan result from history
- **Show**:
  - Scan information card (ID, timestamp, count)
  - Extracted numbers list with numbered badges
  - Cropped image preview
  - Copy button functionality
- **Action**: Tap copy button
- **Show**: "Numbers copied to clipboard" confirmation

### 5. Additional Features (10-15 seconds)
- **Action**: Navigate back and demonstrate:
  - Delete functionality (long press or menu)
  - Empty state when no scans exist
  - Error handling (cover camera lens and try to scan)

## Key Points to Highlight

### Technical Features
- **Real-time camera preview** with responsive overlay
- **Precise image cropping** to rectangle bounds
- **OCR processing** with number extraction and filtering
- **Local database storage** with SQLite
- **Proper error handling** and user feedback

### User Experience
- **Intuitive interface** with clear visual guides
- **Smooth navigation** between screens
- **Comprehensive history management**
- **Copy-to-clipboard functionality**
- **Proper permission handling**

### Performance
- **Optimized image processing** with background cropping
- **Minimal app size** with essential dependencies only
- **Responsive UI** with proper loading states
- **Efficient database operations**

## Demo Tips

1. **Prepare test materials**: Have documents with clear numbers ready
2. **Good lighting**: Ensure adequate lighting for better OCR accuracy
3. **Steady hands**: Keep device steady during capture for best results
4. **Show variety**: Demonstrate different number formats (integers, decimals)
5. **Error scenarios**: Show graceful error handling when OCR fails

## Expected Results

- **OCR Accuracy**: 85-95% for clear, well-lit numbers
- **Processing Time**: 1-3 seconds per capture
- **App Performance**: Smooth 60fps UI interactions
- **Storage**: Minimal space usage with efficient image compression