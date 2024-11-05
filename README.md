# Professional Contact NFC App

A lightweight, fast, and privacy-focused app for sharing your professional contact details via NFC, QR Code, or by sending them to other applications. Ideal for entrepreneurs or small business owners who need a hassle-free way to share their contact information. No ads, no trackers, and free forever!

---

## Table of Contents
1. [Introduction](#introduction)
2. [Features](#features)
3. [Why This App?](#why-this-app)
4. [How It Works](#how-it-works)
5. [Tech Stack](#tech-stack)
6. [Contributing](#contributing)
7. [License](#license)
8. [Developing the App](#developing-the-app)

---

## Introduction

Inspired by physical business cards like [Taggo](https://taggo.one/) and [Monocard](https://monocard.com.br/), this app provides a modern, digital alternative that eliminates the need for carrying a card. Perfect for small businesses or startups, this app is **free**, **lightweight**, and **convenient**, helping you share your professional details instantly with NFC or QR codes.

## Features

- **Share your professional contact** easily:
  - Via NFC (for NFC-enabled devices)
  - Via QR Code (for all devices)
  - As a Virtual Contact Card (vCard)
- **Privacy first**: No ads or trackers.
- **Light and fast**: Under 10 MB.
- **Disable error reporting** for enhanced privacy (enabled by default).
- **Open-source**: Free forever under AGPL-3.0.
- **Supports multiple languages**.
- Available for **Android** (iOS coming soon).

## Why This App?

Other NFC-based contact-sharing solutions, like physical cards, can be expensive and less practical. With this app, you can:
- Share your contact details instantly without carrying an additional card.
- Ensure privacy and control over your data.
- Enjoy a completely **ad-free** experience.
- Use it free of cost—now and forever, backed by an open-source license.

## How It Works

Phones with NFC support can share contact details by simply tapping devices together. For phones without NFC, you can generate a QR code that can be scanned. Additionally, you can export and share your contact as a vCard, enabling seamless integration with other apps.

---

## Tech Stack

This is a [Flutter](https://flutter.dev/) app, utilizing the following open-source packages:

- **[device_info_plus](https://pub.dev/packages/device_info_plus)**: For retrieving device info.
- **[easy_localization](https://pub.dev/packages/easy_localization)**: For multi-language support.
- **[http](https://pub.dev/packages/http)**: For optional error logging (user-controlled).
- **[nfc_manager](https://pub.dev/packages/nfc_manager)**: For NFC functionality (upgraded in future releases).
- **[package_info_plus](https://pub.dev/packages/package_info_plus)**: To gather app information.
- **[path_provider](https://pub.dev/packages/path_provider)**: For managing app storage, e.g., vCards.
- **[provider](https://pub.dev/packages/provider)**: For state management.
- **[qr_flutter](https://pub.dev/packages/qr_flutter)**: For generating QR codes.
- **[share_plus](https://pub.dev/packages/share_plus)**: For sharing the vCard through other apps.
- **[shared_preferences](https://pub.dev/packages/shared_preferences)**: For storing non-sensitive information.
- **[url_launcher](https://pub.dev/packages/url_launcher)**: For URL handling.

---

## Contributing

We welcome contributors! Whether it's adding translations, fixing bugs, or developing new features, your help is invaluable. 

### How to Contribute:
1. Start by creating an Issue to discuss your ideas or problems.
2. After discussions, feel free to submit a Pull Request.
3. Before contributing, you’ll need to sign a Contributor License Agreement (CLA)—handled by a bot in this repo.

**Ways to contribute:**
- Translation
- Bug fixes
- Feature development

---

## License

This app is licensed under the [AGPL-3.0 License](./LICENSE). This ensures that any forks of the app **must** remain open-source and clearly show what changes have been made. Commercial use is allowed, but the source code must always be accessible.

We chose this license to guarantee that the app remains free and open-source forever. If you wish to contribute, please note that your contributions may be used commercially to support the financial sustainability of the project, but the app itself will always remain free.

---

## Developing the App

### Prerequisites

If you're using **Windows**, it's recommended to run the following commands in either [WSL](https://learn.microsoft.com/en-us/windows/wsl/) or [DevContainers](https://containers.dev/).

### Setup and Run
1. **Run** `make setup`:
   - This will guide you through code signing setup (it might open a browser link with instructions from Flutter).
2. **Run** the app on a device:
   - `flutter run -d <your_device> --dart-define-from-file=variables.json` (you can list devices with `flutter devices`). If the `--dart-define-from-file` flag is omitted, default values will be used.

#### VSCode Users
A pre-configured `.vscode/launch.json` file is provided, enabling easy setup with the Flutter/Dart VSCode extension.

### Makefile Commands
You can use the following commands from the `Makefile`:
- `make apk` – Build APK.
- `make appbundle` – Build Android AppBundle.
- `make analyze` – Analyze Android ARM64 version size structure.
- `make run` – Run the app on the default device using `--dart-define-from-file`.
- `make clean` – Clean pub caches.
- `make upgrade` – Upgrade pub dependencies.
- `make outdated` – Check for outdated packages.
- `make get` – Get pub packages.
- `make icons` – Generate app icons from `assets/icon/icon.png`.
- `make get_native_symbols` – Get native symbols for publishing on Play Store.

---

## Join Us in Building a Better App

We're excited to have you contribute to this project. Whether you're helping with translations, fixing bugs, or adding features, your input is highly valued. Before submitting a pull request, please create an issue to discuss your ideas.
