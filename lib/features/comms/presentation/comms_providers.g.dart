// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comms_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommsMessages)
const commsMessagesProvider = CommsMessagesProvider._();

final class CommsMessagesProvider
    extends $NotifierProvider<CommsMessages, List<CommsMessage>> {
  const CommsMessagesProvider._()
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CommsMessage> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CommsMessage>>(value),
    );
  }
}

String _$commsMessagesHash() => r'aad7c9000615b5893c3784c07cd5abeaec3921c7';

abstract class _$CommsMessages extends $Notifier<List<CommsMessage>> {
  List<CommsMessage> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<CommsMessage>, List<CommsMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CommsMessage>, List<CommsMessage>>,
              List<CommsMessage>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(filteredMessages)
const filteredMessagesProvider = FilteredMessagesFamily._();

final class FilteredMessagesProvider
    extends
        $FunctionalProvider<
          List<CommsMessage>,
          List<CommsMessage>,
          List<CommsMessage>
        >
    with $Provider<List<CommsMessage>> {
  const FilteredMessagesProvider._({
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

String _$filteredMessagesHash() => r'9da4f086c91f14d1c9bac7257bcc3be8321beea5';

final class FilteredMessagesFamily extends $Family
    with $FunctionalFamilyOverride<List<CommsMessage>, CommsChannel> {
  const FilteredMessagesFamily._()
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
