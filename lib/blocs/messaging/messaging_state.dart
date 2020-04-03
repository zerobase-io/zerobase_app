import 'package:equatable/equatable.dart';

class MessagingState extends Equatable {
	final List<String> handledMessageIds;

  MessagingState(this.handledMessageIds);

  @override
  List<Object> get props => [handledMessageIds];
}