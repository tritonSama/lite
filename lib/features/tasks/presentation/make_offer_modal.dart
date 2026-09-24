import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../domain/offer.dart';
import '../data/offer_repository.dart';
import '../../teams/presentation/team_providers.dart';

class MakeOfferModal extends ConsumerStatefulWidget {
  final String taskId;

  const MakeOfferModal({super.key, required this.taskId});

  @override
  ConsumerState<MakeOfferModal> createState() => _MakeOfferModalState();
}

class _MakeOfferModalState extends ConsumerState<MakeOfferModal> {
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitOffer() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a bid amount.')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final currentTeamId = ref.read(selectedTeamProvider);

      final offer = Offer(
        id: const Uuid().v4(),
        taskId: widget.taskId,
        providerId: currentTeamId ?? 'unknown_provider', // Fallback if no team selected
        amount: amount,
        message: _messageController.text.trim(),
        createdAt: DateTime.now(),
      );

      await ref.read(offerRepositoryProvider).placeOffer(offer);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offer placed successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place offer: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: HBSpacing.md,
        right: HBSpacing.md,
        top: HBSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Make an Offer', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: HBSpacing.md),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Bid Amount (\$)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
          const SizedBox(height: HBSpacing.md),
          TextField(
            controller: _messageController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Message / Note (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: HBSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isSubmitting ? null : _submitOffer,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Submit Offer'),
            ),
          ),
          const SizedBox(height: HBSpacing.lg),
        ],
      ),
    );
  }
}
