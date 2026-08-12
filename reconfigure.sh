rm -rf ~/.pub-cache/
rm -rf "./flutter_pub_cache"
find . -type f -name '*.g.dart' -print -delete && find . -type f -name '*.freezed.dart' -print -delete && find . -type f -name '*.mocks.dart' -print -delete
flutter clean
rm pubspec.lock
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
cd ios
rm Podfile.lock
pod repo update
pod install
cd ..
