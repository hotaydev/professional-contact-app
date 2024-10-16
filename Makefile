apk:
	flutter build apk --release

appbundle:
	flutter build appbundle --release

isar:
	dart run build_runner build

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

.PHONY: build
