enum MessageType {
	GET_TESTED,
  SELF_ISOLATE
}

extension on MessageType {
	String value() {
		return this.toString().split('.').last;
	}

	static MessageType valueOf(String string) {
		switch(string) {
			case "GET_TESTED":
				return MessageType.GET_TESTED;
			case "SELF_ISOLATE":
				return MessageType.SELF_ISOLATE;
			default:
				throw(string + " is not a valid message type!");
		}
	}
}