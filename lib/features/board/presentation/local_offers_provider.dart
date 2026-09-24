import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tasks/data/offer_repository.dart';
import '../../tasks/domain/offer.dart';
import '../../teams/presentation/team_providers.dart';

final myOffersProvider = FutureProvider<List<Offer>>((ref) async {
  final teamId = ref.watch(selectedTeamProvider);
  if (teamId == null) return [];
  return ref.watch(offerRepositoryProvider).getOffersByProvider(teamId);
});
