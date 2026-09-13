/// Русские склонения по числу.
///
/// Пример:
///   pluralRu(1, 'счёт', 'счёта', 'счетов') -> '1 счёт'
///   pluralRu(2, 'счёт', 'счёта', 'счетов') -> '2 счёта'
///   pluralRu(5, 'счёт', 'счёта', 'счетов') -> '5 счетов'
///   pluralRu(3, 'транзакция', 'транзакции', 'транзакций') -> '3 транзакции'
String pluralRu(int n, String one, String few, String many) {
  final mod10 = n % 10;
  final mod100 = n % 100;
  String word;
  if (mod10 == 1 && mod100 != 11) {
    word = one;
  } else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
    word = few;
  } else {
    word = many;
  }
  return '$n $word';
}
