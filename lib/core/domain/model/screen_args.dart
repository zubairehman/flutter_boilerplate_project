// You can pass any object to the arguments parameter.
// In this example, create a class that contains a customizable
// key and value.
class ScreenArguments<T> {
  final String? key;
  final T? value;

  ScreenArguments({this.key, this.value});
}

class ScreenArgumentKeys {
  ScreenArgumentKeys._();

  static const String bookingId = 'booking_id';
}
