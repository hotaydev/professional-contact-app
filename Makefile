apk:
	flutter build apk --release

appbundle:
	flutter build appbundle --release

analyze:
	flutter build appbundle --target-platform android-arm64 --analyze-size

clean:
	flutter clean

upgrade:
	flutter packages upgrade

outdated:
	flutter packages outdated

get:
	flutter pub get

icons:
	dart run flutter_launcher_icons

.PHONY: apk
