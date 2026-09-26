import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/theme.dart';
import '../../../core/blockchain/fluoridian_service.dart';
import '../../../core/blockchain/models/network_event.dart';

/// Sprint 4: Task Execution & Proof-of-Work Verification Page
/// Supports photographic evidence upload and escrow release approval/dispute.
/// Target Platforms: Android and Web.
class TaskVerificationPage extends ConsumerStatefulWidget {
  final String taskId;
  final bool isCreator;

  const TaskVerificationPage({
    required this.taskId,
    this.isCreator = false,
    super.key,
  });

  @override
  ConsumerState<TaskVerificationPage> createState() => _TaskVerificationPageState();
}

class _TaskVerificationPageState extends ConsumerState<TaskVerificationPage> {
  final List<String> _proofPhotos = [];
  final _notesCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _proofPhotos.add(picked.path));
    }
  }

  Future<void> _submitVerification() async {
    setState(() => _isSubmitting = true);
    final fluoridian = ref.read(fluoridianServiceProvider);

    await fluoridian.signAndBroadcast(
      eventType: NetworkEventType.taskVerified,
      payload: {
        'taskId': widget.taskId,
        'action': 'SUBMITTED_FOR_VERIFICATION',
        'proofPhotos': _proofPhotos,
        'notes': _notesCtrl.text.trim(),
        'submittedAt': DateTime.now().toIso8601String(),
      },
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completion evidence submitted for verification!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  Future<void> _reviewVerification({required bool approve}) async {
    setState(() => _isSubmitting = true);
    final fluoridian = ref.read(fluoridianServiceProvider);

    final eventType = approve ? NetworkEventType.taskVerified : NetworkEventType.taskDisputed;
    await fluoridian.signAndBroadcast(
      eventType: eventType,
      payload: {
        'taskId': widget.taskId,
        'action': approve ? 'APPROVED' : 'DISPUTED',
        'reviewedAt': DateTime.now().toIso8601String(),
      },
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(approve ? 'Task approved! Escrow funds released to provider.' : 'Task marked as Disputed.'),
          backgroundColor: approve ? Colors.green : Colors.redAccent,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCreator ? 'Review Work Verification' : 'Submit Proof of Work'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Task ID: ${widget.taskId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Status: In Verification', style: TextStyle(color: HBColors.primary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text(
                      'All proof photos and location telemetry are cryptographically sealed in the Fluoridian Event Envelope before releasing bounty escrow.',
                      style: TextStyle(fontSize: 12, color: HBColors.onSurfaceVariantDark),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Proof photos section
            const Text('Proof-of-Work Photos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_proofPhotos.isEmpty)
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('No completion photos captured yet.', style: TextStyle(color: HBColors.onSurfaceVariantDark)),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _proofPhotos.map((p) => Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image, size: 40, color: HBColors.onSurfaceVariantDark),
                )).toList(),
              ),
            const SizedBox(height: 12),
            if (!widget.isCreator)
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Add Completion Photo'),
              ),

            const SizedBox(height: 20),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              readOnly: widget.isCreator,
              decoration: InputDecoration(
                labelText: widget.isCreator ? 'Provider Completion Notes' : 'Completion Notes',
                hintText: widget.isCreator ? 'No notes provided' : 'Describe the completed work...',
              ),
            ),

            const SizedBox(height: 32),
            if (_isSubmitting)
              const Center(child: CircularProgressIndicator())
            else if (!widget.isCreator)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submitVerification,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Submit for Creator Verification'),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _reviewVerification(approve: false),
                      icon: const Icon(Icons.warning, color: Colors.orangeAccent),
                      label: const Text('Dispute'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _reviewVerification(approve: true),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Approve & Release Funds'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
