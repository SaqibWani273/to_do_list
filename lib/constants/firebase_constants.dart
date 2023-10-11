enum AuthExceptionEnum {
  accountExistsWithDifferentCredential,
  invalidCredential,
  operationNotAllowed,
  userDisabled,
  userNotFound,
  wrongPassword,
  invalidVerificationCode,
  invalidVerificationId,
  unknownError,
}

class AuthExceptionMapper {
  static AuthExceptionEnum map(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return AuthExceptionEnum.accountExistsWithDifferentCredential;
      case 'invalid-credential':
        return AuthExceptionEnum.invalidCredential;
      case 'operation-not-allowed':
        return AuthExceptionEnum.operationNotAllowed;
      case 'user-disabled':
        return AuthExceptionEnum.userDisabled;
      case 'user-not-found':
        return AuthExceptionEnum.userNotFound;
      case 'wrong-password':
        return AuthExceptionEnum.wrongPassword;
      case 'invalid-verification-code':
        return AuthExceptionEnum.invalidVerificationCode;
      case 'invalid-verification-id':
        return AuthExceptionEnum.invalidVerificationId;
      default:
        return AuthExceptionEnum.unknownError;
    }
  }
}
