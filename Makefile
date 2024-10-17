apk:
	flutter build apk --release --tree-shake-icons

appbundle:
	flutter build appbundle --release --tree-shake-icons

analyze:
	flutter build appbundle --target-platform android-arm64 --tree-shake-icons --analyze-size

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
