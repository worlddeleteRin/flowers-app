import 'package:myapp/src/models/user_model.dart';
import 'package:rxdart/subjects.dart';

class DeliveryAddressBloc {
  /*
  final UserDeliveryAddress address;
  DeliveryAddressBloc({
    required this.address
  });
  */

  final _city = BehaviorSubject<String>.seeded("");
  final _street = BehaviorSubject<String>.seeded("");

  Stream<String> get city => _city.stream;
  Stream<String> get street => _street.stream;

  Sink<String> get sinkCity => _city.sink;
  Sink<String> get sinkStreet => _street.sink;

  dispose() {
    _city.close();
    _street.close();
  }

}

final DeliveryAddressBloc deliveryAddressBloc = 
DeliveryAddressBloc();


