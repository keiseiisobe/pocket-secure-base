import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/strategic_planner_api.dart';
import '../domain/route_plan.dart';
import '../providers/strategic_planner_provider.dart';

/// Strategic planning phase: sensory preferences, route overview, Maps handoff.
class PlanRouteScreen extends ConsumerStatefulWidget {
  const PlanRouteScreen({super.key});

  static const List<String> kSensoryPreferenceIds = <String>[
    'avoid_loud_areas',
    'avoid_crowds',
    'avoid_bright_light',
  ];

  @override
  ConsumerState<PlanRouteScreen> createState() => _PlanRouteScreenState();
}

class _PlanRouteScreenState extends ConsumerState<PlanRouteScreen> {
  final TextEditingController _originCtrl = TextEditingController();
  final TextEditingController _destinationCtrl = TextEditingController();

  final Set<String> _selectedSensory = <String>{};

  RoutePlanView? _plan;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _originCtrl.dispose();
    _destinationCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestPlan() async {
    final destination = _destinationCtrl.text.trim();
    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a destination.')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final StrategicPlannerApi api = ref.read(strategicPlannerApiProvider);

    try {
      final plan = await api.requestPlan(
        origin: _originCtrl.text.trim(),
        destination: destination,
        sensoryPreferences: _selectedSensory.toList(),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _plan = plan;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _plan = null;
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _openNavigation(RoutePlanView plan) async {
    final uri = Uri.parse(plan.navigationUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  String _prefLabel(String id) {
    switch (id) {
      case 'avoid_loud_areas':
        return 'Avoid loud areas';
      case 'avoid_crowds':
        return 'Avoid crowds';
      case 'avoid_bright_light':
        return 'Avoid harsh light';
      default:
        return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan route'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Secure base',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tell DeepBreath where you want to go and what to soften along the way. '
              'You stay in control until you choose to open Maps.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _originCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Origin (optional)',
                hintText: 'Leave blank to use your location in Google Maps',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _destinationCtrl,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Destination',
                hintText: 'e.g. Ueno Park, Tokyo',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sensory preferences',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final id in PlanRouteScreen.kSensoryPreferenceIds)
                  FilterChip(
                    label: Text(_prefLabel(id)),
                    selected: _selectedSensory.contains(id),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSensory.add(id);
                        } else {
                          _selectedSensory.remove(id);
                        }
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _loading ? null : _requestPlan,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.route_outlined),
              label: Text(_loading ? 'Planning…' : 'Request route plan'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Material(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SelectableText(
                    _error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                  ),
                ),
              ),
            ],
            if (_plan != null) ...[
              const SizedBox(height: 28),
              Text(
                'Route overview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(_plan!.routeOverview),
              const SizedBox(height: 16),
              Text(
                'Why these choices',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              for (final item in _plan!.rationaleItems)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(item.detail),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (_plan!.waypoints.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Tactical waypoints (max 9)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                for (final wp in _plan!.waypoints)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.place_outlined),
                    title: Text(wp.label),
                    subtitle: Text(wp.address),
                  ),
              ],
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openNavigation(_plan!),
                icon: const Icon(Icons.navigation_outlined),
                label: const Text('Start navigation'),
              ),
              const SizedBox(height: 12),
              Text(
                'Opens the native Google Maps app with tactical waypoints when available.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              if (_plan!.toolMetadata.isNotEmpty) ...[
                const SizedBox(height: 16),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Planner notes',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SelectableText(
                        _plan!.toolMetadata.entries
                            .map((e) => '${e.key}: ${e.value}')
                            .join('\n'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
