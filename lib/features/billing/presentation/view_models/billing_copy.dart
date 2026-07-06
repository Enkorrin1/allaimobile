const billingReserveCopy =
    'Коины резервируются при запуске. Если генерация не завершится, мы вернем их автоматически.';
const insufficientCoinsCopy = 'Недостаточно койнов';
const topUpBalanceCopy = 'Покупки будут подключены позже';
const billingUnavailableCopy =
    'Покупки пока отключены в этой сборке. Баланс, пакеты и история операций работают в локальном режиме.';

String insufficientCoinsQuoteCopy({required int cost, required int available}) {
  return 'Недостаточно койнов: нужно $cost, доступно $available';
}
