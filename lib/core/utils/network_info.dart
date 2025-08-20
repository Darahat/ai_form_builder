import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Abstract class defining network connectivity checking functionality
abstract class NetworkInfo {
  /// Checks if the device has an active internet connection
  Future<bool> get isConnected;
}

/// Implementation of [NetworkInfo] using the connectivity_plus package
@Injectable(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  /// Creates a [NetworkInfoImpl] with the required [Connectivity] instance
  NetworkInfoImpl(this.connectivity);

  /// The connectivity service used to check network status
  final Connectivity connectivity;

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
