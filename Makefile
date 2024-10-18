apk:
	flutter build apk --release --tree-shake-icons

appbundle:
	flutter build appbundle --release --tree-shake-icons

analyze:
	flutter build appbundle --target-platform android-arm64 --tree-shake-icons --analyze-size

clean:
	flutter clean
	flutter pub get

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

.PHONY: apk
