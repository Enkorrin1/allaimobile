import 'package:allai_mobile/app/allai_app.dart';
import 'package:allai_mobile/shared/widgets/template_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpAllAi(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: AllAiApp()));
  await tester.pumpAndSettle();
}

Future<void> scrollCurrentScreen(
  WidgetTester tester, [
  double distance = 720,
]) async {
  await tester.drag(find.byType(Scrollable).last, Offset(0, -distance));
  await tester.pumpAndSettle();
}

Future<void> scrollUntilBuilt(
  WidgetTester tester,
  Finder finder, {
  int maxScrolls = 5,
}) async {
  for (var i = 0; i < maxScrolls && !tester.any(finder); i += 1) {
    await scrollCurrentScreen(tester);
  }
}

void main() {
  testWidgets('AllAI shell renders main navigation', (tester) async {
    await pumpAllAi(tester);

    expect(find.text('AllAI Studio'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Studio'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Баланс: 1 250 койнов'), findsOneWidget);
  });

  testWidgets('Create tab renders static generator UI', (tester) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Start a generation'), findsOneWidget);
    expect(find.text('Prompt'), findsOneWidget);

    final costPreview = find.text('Стоимость: от 80 койнов');
    await scrollUntilBuilt(tester, costPreview);
    expect(costPreview.last, findsOneWidget);
  });

  testWidgets('Tools and template detail routes render', (tester) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('Browse tools'));
    await tester.pumpAndSettle();

    expect(find.text('Creative tools'), findsOneWidget);
    expect(find.text('AllAI Photo Studio'), findsOneWidget);

    final productTemplate = find.widgetWithText(
      TemplateCard,
      'Product UGC Hook',
    );
    await scrollUntilBuilt(tester, productTemplate);
    await tester.tap(productTemplate.last);
    await tester.pumpAndSettle();

    await scrollUntilBuilt(tester, find.text('Required inputs'));
    expect(find.text('Required inputs'), findsOneWidget);
    expect(find.text('Use template'), findsOneWidget);
  });

  testWidgets('Create can open result viewer mock', (tester) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    final openResult = find.text('Open mock result');
    await scrollUntilBuilt(tester, openResult);
    await tester.tap(openResult.last);
    await tester.pumpAndSettle();

    expect(find.text('Product hero shot'), findsWidgets);
    await scrollUntilBuilt(tester, find.text('Save'));
    expect(find.text('Save'), findsOneWidget);
    await scrollUntilBuilt(tester, find.text('Metadata'));
    expect(find.text('Metadata'), findsOneWidget);
  });

  testWidgets('Pricing route renders disabled demo billing', (tester) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('Баланс: 1 250 койнов'));
    await tester.pumpAndSettle();

    expect(find.text('Coins'), findsOneWidget);
    expect(find.text('Demo packages'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Пополнить баланс'), 360);
    expect(find.text('Пополнить баланс'), findsOneWidget);
  });

  testWidgets('Library and Studio tabs render static content', (tester) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('History and reuse'), findsOneWidget);
    expect(find.text('Product hero shot'), findsOneWidget);

    await tester.tap(find.text('Studio'));
    await tester.pumpAndSettle();
    expect(find.text('Social studio'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Create social asset'), 360);
    expect(find.text('Create social asset'), findsOneWidget);
  });
}
