import 'dart:async';
import 'package:decart_vton_flutter/decart_vton_flutter.dart';
import 'package:fitting_room/services/try_on_gateway.dart';

class FakeGateway implements TryOnGateway {
  final stateChanges = StreamController<VtonConnectionState>.broadcast(
    sync: true,
  );
  final errorChanges = StreamController<DecartVtonException>.broadcast();
  final eventChanges = StreamController<VtonEvent>.broadcast();
  Completer<void>? initializing;
  Completer<void>? connecting;
  int initializeCalls = 0;
  int closeCalls = 0;
  Object? disconnectError;
  int connectCalls = 0;
  int disconnectCalls = 0;
  final applied = <VtonOutfit>[];
  @override
  Stream<VtonConnectionState> get states => stateChanges.stream;
  @override
  Stream<DecartVtonException> get errors => errorChanges.stream;
  @override
  Stream<VtonEvent> get events => eventChanges.stream;
  @override
  Future<void> initialize() async {
    initializeCalls++;
    await initializing?.future;
  }

  @override
  Future<void> connect(VtonOutfit outfit) async {
    connectCalls++;
    stateChanges.add(VtonConnectionState.connecting);
    await connecting?.future;
    if (!stateChanges.isClosed) {
      stateChanges.add(VtonConnectionState.generating);
    }
  }

  @override
  Future<void> disconnect() async {
    disconnectCalls++;
    if (disconnectError != null) throw disconnectError!;
    stateChanges.add(VtonConnectionState.disconnected);
  }

  @override
  Future<void> apply(VtonOutfit outfit) async {
    applied.add(outfit);
  }

  @override
  Future<void> switchCamera() async {}
  @override
  Future<void> close() async {
    closeCalls++;
    await stateChanges.close();
    await errorChanges.close();
    await eventChanges.close();
  }
}
