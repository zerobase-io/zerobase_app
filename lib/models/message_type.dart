enum MessageType { GET_TESTED, SELF_ISOLATE, PLEASE_CALL, CUSTOM }

extension on MessageType {
  String value() {
    return this.toString().split('.').last;
  }

  static MessageType valueOf(String string) {
    switch (string) {
      case "GET_TESTED":
        return MessageType.GET_TESTED;
      case "SELF_ISOLATE":
        return MessageType.SELF_ISOLATE;
      case "PLEASE_CALL":
        return MessageType.PLEASE_CALL;
      case "CUSTOM":
        return MessageType.CUSTOM;
      default:
        throw (string + " is not a valid message type!");
    }
  }
}
