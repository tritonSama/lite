// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comms_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommsMessages)
final commsMessagesProvider = CommsMessagesProvider._();

final class CommsMessagesProvider
    extends $AsyncNotifierProvider<CommsMessages, List<CommsMessage>> {
  CommsMessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commsMessagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commsMessagesHash();

  @$internal
  @override
  CommsMessages create() => CommsMessages();
}

String _$commsMessagesHash() => r'6118bb050f35b987f10d10f6f0b7c5961f78d803';

abstract class _$CommsMessages extends $AsyncNotifier<List<CommsMessage>> {
  FutureOr<List<CommsMessage>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<CommsMessage>>, List<CommsMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CommsMessage>>, List<CommsMessage>>,
              AsyncValue<List<CommsMessage>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedCommsTarget)
final selectedCommsTargetProvider = SelectedCommsTargetProvider._();

final class SelectedCommsTargetProvider
    extends $NotifierProvider<SelectedCommsTarget, String?> {
  SelectedCommsTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCommsTargetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCommsTargetHash();

  @$internal
  @override
  SelectedCommsTarget create() => SelectedCommsTarget();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedCommsTargetHash() =>
    r'a7ed7db748b6b0e1f558c8f26afabdb0ebb08b67';

abstract class _$SelectedCommsTarget extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredMessages)
final filteredMessagesProvider = FilteredMessagesFamily._();

final class FilteredMessagesProvider
    extends
        $FunctionalProvider<
          List<CommsMessage>,
          List<CommsMessage>,
          List<CommsMessage>
        >
    with $Provider<List<CommsMessage>> {
  FilteredMessagesProvider._({
    required FilteredMessagesFamily super.from,
    required CommsChannel super.argument,
  }) : super(
         retry: null,
         name: r'filteredMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredMessagesHash();

  @override
  String toString() {
    return r'filteredMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<CommsMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<CommsMessage> create(Ref ref) {
    final argument = this.argument as CommsChannel;
    return filteredMessages(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CommsMessage> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CommsMessage>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredMessagesHash() => r'e22cafa01a1ba5990a1cc5eb88453a425f8495fd';

final class FilteredMessagesFamily extends $Family
    with $FunctionalFamilyOverride<List<CommsMessage>, CommsChannel> {
  FilteredMessagesFamily._()
    : super(
        retry: null,
        name: r'filteredMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilteredMessagesProvider call(CommsChannel channel) =>
      FilteredMessagesProvider._(argument: channel, from: this);

  @override
  String toString() => r'filteredMessagesProvider';
}
