build:
	flutter build apk --release

isar:
	dart run build_runner build

clean:
	flutter clean

upgrade:
	flutter packages upgrade

get:
	flutter pub get

.PHONY: build
