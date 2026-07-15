import 'package:allai_mobile/app/router/app_routes.dart';
import 'package:allai_mobile/l10n/app_localizations.dart';
import 'package:allai_mobile/shared/widgets/result_action_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create draft route preserves reusable generation fields', () {
    final route = AppRoutes.createDraft(
      format: 'video',
      modelId: 'kling',
      prompt: 'cinematic portrait',
      sourceAssetId: 'asset-42',
    );
    final uri = Uri.parse(route);

    expect(uri.path, AppRoutes.create);
    expect(uri.queryParameters['format'], 'video');
    expect(uri.queryParameters['model'], 'kling');
    expect(uri.queryParameters['prompt'], 'cinematic portrait');
    expect(uri.queryParameters['source'], 'asset-42');
  });

  testWidgets('result action bar exposes repeat and reuse actions', (
    tester,
  ) async {
    var repeatCount = 0;
    var sourceCount = 0;
    var upscaleCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ResultActionBar(
            onRepeat: () => repeatCount += 1,
            onUseAsSource: () => sourceCount += 1,
            onUpscale: () => upscaleCount += 1,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Retry'));
    await tester.tap(find.text('Add image'));
    await tester.tap(find.text('Upscale'));

    expect(repeatCount, 1);
    expect(sourceCount, 1);
    expect(upscaleCount, 1);
  });
}
