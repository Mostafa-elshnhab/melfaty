abstract class LogiStates {}

class InitialLoginState extends LogiStates {}

class ChangePasswordState extends LogiStates {}

class LoginLodaingState extends LogiStates {}

class CreateUserSuccessState extends LogiStates {}


class LoginGoogleLodaingState extends LogiStates {}

class LoginScssesState extends LogiStates {
  final String? uId;

  LoginScssesState(this.uId);
}

class LoginGoogleScssesState extends LogiStates {
  final String? uId;

  LoginGoogleScssesState(this.uId);
}

class LoginErorrState extends LogiStates {
  String? error;

  LoginErorrState(this.error);
}

class LoginGoogleErrorState extends LogiStates {
  String? error;

  LoginGoogleErrorState(this.error);
}

class CreateUserErrorState extends LogiStates {
  String? error;

  CreateUserErrorState(this.error);
}
