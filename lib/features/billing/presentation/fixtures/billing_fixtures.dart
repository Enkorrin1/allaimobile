class DemoCoinPackage {
  const DemoCoinPackage({
    required this.name,
    required this.amountLabel,
    required this.description,
    required this.highlighted,
  });

  final String name;
  final String amountLabel;
  final String description;
  final bool highlighted;
}

class DemoTransaction {
  const DemoTransaction({
    required this.title,
    required this.dateLabel,
    required this.amountLabel,
  });

  final String title;
  final String dateLabel;
  final String amountLabel;
}

const demoBalanceLabel = 'Баланс: 1 250 койнов';
const demoCostLabel = 'Стоимость: от 80 койнов';
const demoReserveCopy =
    'Койны зарезервируются при запуске. При сбое генерации мы вернем их автоматически.';
const demoInsufficientCoinsCopy = 'Недостаточно койнов для этой генерации';
const demoTopUpCopy = 'Пополнить баланс';
const demoPackagesNotice =
    'Пакеты показаны для демо. Реальные покупки будут подключены после решения по App Store / Google Play.';

const demoCoinPackages = [
  DemoCoinPackage(
    name: 'Start',
    amountLabel: '1 000 койнов',
    description: 'Для первых тестов и prompt-only изображений.',
    highlighted: false,
  ),
  DemoCoinPackage(
    name: 'Creator',
    amountLabel: '5 000 койнов',
    description: 'Оптимальный пакет для регулярных social creatives.',
    highlighted: true,
  ),
  DemoCoinPackage(
    name: 'Pro',
    amountLabel: '12 000 койнов',
    description: 'Для видео, try-on и серийных вариаций.',
    highlighted: false,
  ),
  DemoCoinPackage(
    name: 'Studio',
    amountLabel: '30 000 койнов',
    description: 'Для командного контент-пайплайна и high-volume задач.',
    highlighted: false,
  ),
];

const demoTransactions = [
  DemoTransaction(
    title: 'Product hero shot',
    dateLabel: 'Сегодня, 14:20',
    amountLabel: '-80',
  ),
  DemoTransaction(
    title: 'Failed motion draft refund',
    dateLabel: 'Вчера, 10:19',
    amountLabel: '+180',
  ),
  DemoTransaction(
    title: 'Demo balance grant',
    dateLabel: 'Phase 2',
    amountLabel: '+1 250',
  ),
];
