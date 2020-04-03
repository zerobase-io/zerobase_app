import 'dart:core';
import 'package:equatable/equatable.dart';

class DeviceIdState extends Equatable {
  @override
  List<Object> get props => [];
}

class DeviceIdEmptyState extends DeviceIdState {}

class DeviceIdLoadedState extends DeviceIdState {
  final String deviceId;
  final List<String> alternateIds;

  DeviceIdLoadedState(this.deviceId, this.alternateIds) : super();

  @override
  String toString() => "{$deviceId, $alternateIds}";

  @override
  List<Object> get props => super.props..add([deviceId, alternateIds]);
}
