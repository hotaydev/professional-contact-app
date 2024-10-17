import 'package:shared_preferences/shared_preferences.dart';

class ErrorHandler {
  final Object exception;
  final StackTrace stackTrace;

  ErrorHandler(
    this.exception,
    this.stackTrace,
  );

  capture() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // It's true by default, but can be diabled anytime
    final canShareExceptions = preferences.getBool('shareExceptions') ?? true;

    if (canShareExceptions) {
      // TODO: Log errors in an external service
    }
  }
}
