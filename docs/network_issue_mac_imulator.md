# Fix: Android Emulator Not Getting Internet on macOS

This guide documents how to fix the issue where the **Android Emulator on macOS** cannot connect to the internet or Google servers.

---

## 1. Verify Mac Internet Connection

Ensure your Mac has working internet by testing in Safari/Chrome:

```bash
ping -c 4 google.com
```

---

## 2. Verify ADB Works

Check if `adb` is installed:

```bash
adb version
```

If `adb` is not found, add the **platform-tools** path to your shell configuration:

For **zsh** (default on macOS):

```bash
nano ~/.zshrc
```

Add:

```bash
export PATH=$PATH:$HOME/Library/Android/sdk/platform-tools
```

Reload:

```bash
source ~/.zshrc
```

---

## 3. Test Connectivity Inside Emulator

Run:

```bash
adb shell ping -c 4 8.8.8.8
adb shell ping -c 4 google.com
```

- ✅ If `8.8.8.8` works but `google.com` fails → **DNS issue**.
- ❌ If both fail → emulator has no internet at all.

---

## 4. Fix DNS Issue

Force DNS settings inside the emulator:

```bash
adb shell su 0 setprop net.dns1 8.8.8.8
adb shell su 0 setprop net.dns2 8.8.4.4
adb shell getprop | grep dns
```

Or restart emulator with DNS:

```bash
emulator -avd <Your_AVD_Name> -dns-server 8.8.8.8,8.8.4.4
```

---

## 5. Find Your Emulator (AVD) Name

List available AVDs:

```bash
emulator -list-avds
```

Example:

```
Pixel_9
```

---

## 6. Fix `emulator` Command Not Found

If `emulator` is missing, add it to PATH:

```bash
nano ~/.zshrc
```

Add:

```bash
export PATH=$PATH:$HOME/Library/Android/sdk/emulator
```

Reload:

```bash
source ~/.zshrc
```

---

## 7. Restart Emulator with Correct DNS

Close the running emulator:

```bash
adb devices        # find running instance
adb -s emulator-5554 emu kill
```

Then restart with DNS:

```bash
emulator -avd Pixel_9 -dns-server 8.8.8.8,8.8.4.4
```

---

## 8. Verify Fix

Check inside emulator:

```bash
adb shell ping -c 4 google.com
```

If you get replies, the issue is fixed 🎉.

---

## Notes

- Prefer **Google APIs images** (API 33/34) instead of **Google Play images** for more reliable networking on macOS ARM chips.
- Always keep emulator & SDK tools updated:

```bash
sdkmanager --update
```

---

✅ **Problem Solved**: Emulator now has internet access on macOS.
