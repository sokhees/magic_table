# Magic Table - Code Structure

## Refactoring Summary

Code đã được refactor để dễ đọc, dễ maintain và tái sử dụng.

## 📁 Cấu trúc thư mục

```
lib/
├── theme/                      # Theme configuration
│   ├── app_colors.dart        # Màu sắc app (gradient, player colors)
│   ├── app_text_styles.dart   # Text styles (title, body, button, etc.)
│   └── theme.dart             # Export tất cả theme files
│
├── widgets/                    # Reusable widgets
│   ├── gradient_button.dart          # Button với gradient
│   ├── gradient_icon_button.dart     # Icon button với gradient và shadow
│   ├── custom_dialog.dart            # Dialog container có sẵn icon, title, subtitle
│   ├── player_card.dart              # Card hiển thị player (màn hình chính)
│   ├── player_summary_card.dart      # Card summary player (màn hình records)
│   ├── winner_selection_tabs.dart    # Tabs chọn winner (new record popup)
│   ├── loser_point_input.dart        # Input row cho losers (new record popup)
│   └── widgets.dart                  # Export tất cả widgets
│
└── Views/                      # Screens
    ├── card_style_view.dart   # Màn hình chính (✅ Refactored)
    ├── records_page.dart      # Màn hình records (✅ Refactored)
    ├── new_record_popup.dart  # Popup thêm round mới (✅ Refactored)
    ├── pointing_page.dart     # Main page wrapper
    └── record_list.dart       # Danh sách records
```

## 🎨 Theme System

### AppColors

```dart
// Import
import 'package:magic_table/theme/app_colors.dart';

// Usage
Container(
  color: AppColors.backgroundDark,
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
  ),
)

// Player gradient
Container(
  decoration: BoxDecoration(
    gradient: AppColors.playerGradient(index),
  ),
)

// Get player color
Color color = AppColors.getPlayerColor(index, 0.8);
```

### AppTextStyles

```dart
// Import
import 'package:magic_table/theme/app_text_styles.dart';

// Usage
Text('Title', style: AppTextStyles.title)
Text('Body', style: AppTextStyles.bodyLarge)
Text('Score', style: AppTextStyles.largeScore)
Text('Label', style: AppTextStyles.sectionLabel)
```

## 🧩 Reusable Widgets

### GradientButton

```dart
GradientButton(
  text: 'Save',
  icon: Icons.save,
  onPressed: () {},
  gradient: AppColors.primaryGradient, // Optional
  height: 48,
  borderRadius: BorderRadius.circular(12),
)
```

### GradientIconButton

```dart
GradientIconButton(
  icon: Icons.add,
  onPressed: () {},
  gradient: AppColors.blueGradient, // Optional
  size: 28,
)
```

### CustomDialog

```dart
showDialog(
  context: context,
  builder: (context) => CustomDialog(
    title: 'Delete?',
    subtitle: 'This action cannot be undone',
    icon: Icons.warning,
    iconColor: Colors.red,
    actions: [
      GradientButton(text: 'Delete', onPressed: () {}),
      TextButton(child: Text('Cancel'), onPressed: () {}),
    ],
  ),
)
```

### PlayerCard

```dart
PlayerCard(
  playerName: 'Player 1',
  score: 100,
  latestRecord: 10,
  colorIndex: 0,
  onTap: () {},
  onLongPress: () {},
)
```

### PlayerSummaryCard

```dart
PlayerSummaryCard(
  playerName: 'Player 1',
  totalScore: 100,
  colorIndex: 0,
)
```

### WinnerSelectionTabs

```dart
WinnerSelectionTabs(
  players: ['Player 1', 'Player 2'],
  viewModel: viewModel,
)
```

### LoserPointInput

```dart
LoserPointInput(
  playerName: 'Player 1',
  record: record,
  controller: controller,
  onToggleSign: () {},
)
```

## 📊 Refactored Files

### 1. card_style_view.dart

**Before:** 150 lines với logic phức tạp
**After:** 80 lines sử dụng PlayerCard widget

**Improvements:**
- ✅ Removed duplicate gradient color logic
- ✅ Used PlayerCard widget
- ✅ Cleaner code structure

### 2. records_page.dart

**Before:** 150+ lines với nhiều style hardcoded
**After:** 80 lines sử dụng reusable widgets

**Improvements:**
- ✅ Used GradientIconButton cho header buttons
- ✅ Used PlayerSummaryCard cho player cards
- ✅ Removed _getGradientColor method
- ✅ Used AppColors và AppTextStyles

### 3. new_record_popup.dart

**Before:** 545 lines, rất khó đọc
**After:** 140 lines chia thành 4 methods

**Improvements:**
- ✅ Split thành 4 helper methods
  - `_buildHeader()` - Header với close button
  - `_buildWinnerSection()` - Winner selection section
  - `_buildLosersSection()` - Losers input section
  - `_buildSaveButton()` - Save button
- ✅ Used WinnerSelectionTabs widget
- ✅ Used LoserPointInput widget
- ✅ Used GradientButton widget
- ✅ Reduced code by 74%

## 🎯 Benefits

1. **Dễ đọc hơn:** Code được chia nhỏ thành các widget có ý nghĩa rõ ràng
2. **Dễ maintain:** Thay đổi style chỉ cần sửa ở một nơi (theme files)
3. **Tái sử dụng:** Widgets có thể dùng lại ở nhiều màn hình
4. **Consistency:** Màu sắc và text styles thống nhất trong toàn bộ app
5. **Giảm code:** Giảm ~60% số dòng code ở các file phức tạp

## 🚀 Next Steps

1. ✅ Refactor `card_style_view.dart`
2. ✅ Refactor `records_page.dart`
3. ✅ Refactor `new_record_popup.dart`
4. ⏳ Refactor `pointing_page.dart` dialogs
5. ⏳ Refactor `record_list.dart`
6. ⏳ Refactor `statistics_page.dart`

## 📝 Usage Examples

### Import theme và widgets

```dart
// Import theme
import 'package:magic_table/theme/theme.dart';

// Import tất cả widgets
import 'package:magic_table/widgets/widgets.dart';

// Hoặc import riêng lẻ
import 'package:magic_table/theme/app_colors.dart';
import 'package:magic_table/widgets/gradient_button.dart';
```

### Tạo một dialog mới

```dart
showDialog(
  context: context,
  builder: (context) => CustomDialog(
    title: 'Your Title',
    subtitle: 'Your subtitle text',
    icon: Icons.info,
    iconColor: AppColors.info,
    actions: [
      GradientButton(
        text: 'Confirm',
        onPressed: () {
          // Your action
          Navigator.pop(context);
        },
      ),
      const SizedBox(height: 12),
      TextButton(
        child: Text('Cancel', style: AppTextStyles.subtitle),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  ),
);
```
