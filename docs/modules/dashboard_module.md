---

### 8. **`docs/customization.md`**

```markdown
# Customization

## Theme Customization

To change the app's theme, modify `lib/shared/theme/app_theme.dart`:

- Modify colors, fonts, and other visual elements.

## Branding

To change the app's branding (logo, splash screen, etc.):

1. Replace the default images in `assets/images/`.
2. Update the splash screen configuration in `android/app/src/main/res/drawable/`.

## Localization

To add support for multiple languages:

1. Add your translations to `lib/shared/utils/locale.dart`.
2. Use the `Intl` package for string translations.
```
