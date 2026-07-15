import '../../../generation_jobs/domain/generation_job_models.dart';
import '../../../library/domain/library_history_item.dart';

class HomeLibrarySections {
  const HomeLibrarySections({
    required this.active,
    required this.recentResults,
  });

  final List<LibraryHistoryItem> active;
  final List<LibraryHistoryItem> recentResults;

  factory HomeLibrarySections.fromHistory(
    List<LibraryHistoryItem> history, {
    int limit = 3,
  }) {
    final sorted = [...history]
      ..sort((a, b) => b.job.updatedAt.compareTo(a.job.updatedAt));
    return HomeLibrarySections(
      active: sorted.where((item) => !item.job.isTerminal).take(limit).toList(),
      recentResults: sorted
          .where(
            (item) =>
                item.job.status == GenerationJobStatus.completed &&
                item.outputAsset != null,
          )
          .take(limit)
          .toList(),
    );
  }
}
