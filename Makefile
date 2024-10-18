apk:
	flutter build apk --release --dart-define-from-file=variables.json --tree-shake-icons

appbundle:
	flutter build appbundle --release --dart-define-from-file=variables.json --tree-shake-icons

analyze:
	flutter build appbundle --target-platform android-arm64 --dart-define-from-file=variables.json --tree-shake-icons --analyze-size

run:
	flutter run --dart-define-from-file=variables.json

clean:
	flutter clean
	@$(MAKE) get

upgrade:
	flutter packages upgrade

outdated:
	flutter packages outdated

get:
	flutter pub get

icons:
	dart run flutter_launcher_icons

get_native_symbols:
	rm -rf ./build/app/outputs/native_symbols.zip
	cd ./build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib/ && zip ./../../../../../../outputs/native_symbols.zip -r ./

setup:
	if [ ! -f "variables.json" ]; then cp variables-example.json variables.json; fi
	if [ ! -f "android/key.properties" ]; then open https://docs.flutter.dev/deployment/android#sign-the-app; fi
	@$(MAKE) get
	@$(MAKE) upgrade

.PHONY: run
