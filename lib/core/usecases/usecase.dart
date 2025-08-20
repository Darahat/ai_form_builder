///Abstract base class for use cases in the application
///
/// [Type] represents the return type of the use case
/// [Params] represents the parameters required by the use case
abstract class UseCase<Type, Params> {
  /// Executes the use case with the provided parameters
  Future<Type> call(Params params);
}

/// Represents a use case with no input parameters
class NoParams {
  /// No Params constant

  const NoParams();
}

// /// Represents a regisstration params
// class RegisterParams {
//   /// RegisterParams contructor
//   const RegisterParams();
// }
