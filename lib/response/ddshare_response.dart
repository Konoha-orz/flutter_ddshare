const String _mErrCode = "mErrCode";
const String _mErrStr = "mErrStr";
const String _mTransaction = "mTransaction";

typedef BaseDDShareResponse _DDShareResponseInvoker(Map argument);

Map<String, _DDShareResponseInvoker> _nameAndResponseMapper = {
  "onShareResponse": (Map argument) => DDShareResponse.fromMap(argument),
  "onAuthResponse": (Map argument) => DDShareAuthResponse.fromMap(argument),
};

class BaseDDShareResponse {
  final int mErrCode;
  final String mErrStr;
  final String mTransaction;

  bool get isSuccessful => mErrCode == 0;

  BaseDDShareResponse._(this.mErrCode, this.mErrStr, this.mTransaction);

  /// create response from response pool
  factory BaseDDShareResponse.create(String name, Map argument) =>
      _nameAndResponseMapper[name](argument);
}

class DDShareResponse extends BaseDDShareResponse {
  final int type;

  DDShareResponse.fromMap(Map map)
      : type = map["type"],
        super._(map[_mErrCode], map[_mErrStr], map[_mTransaction]);
}

class DDShareAuthResponse extends BaseDDShareResponse {
  final String code;
  final String state;

  DDShareAuthResponse.fromMap(Map map)
      : code = map["code"],
        state = map["state"],
        super._(map[_mErrCode], map[_mErrStr], map[_mTransaction]);
}

class ErrCode {
  static const ERR_OK = 0;
  static const ERR_COMM = -1;
  static const ERR_USER_CANCEL = -2;
  static const ERR_SENT_FAILED = -3;
  static const ERR_AUTH_DENIED = -4;
  static const ERR_UNSUPPORT = -5;
}
