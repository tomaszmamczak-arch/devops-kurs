# Raport z testu wydajności serwera WWW

- **Data wykonania**: 2026-11-19 17:24:18
- **Maszyna testowa**: TOMAM-D, 14 rdzeni, 31Gi RAM
- **Plik danych**: `wyniki-20261119-171700.csv`
- **Kryterium zaliczenia**: p95 poniżej 400 ms przy zerowej liczbie błędów

## Wyniki pomiarów

| Konkurencja | RPS | p50 [ms] | p95 [ms] | p99 [ms] | Błędy | Ocena |
|-------------|-----|----------|----------|----------|-------|-------|
| 10 | 55555.6 | 0 | 0 | 1 | 0 | zaliczony |
| 25 | 139791.7 | 0 | 0 | 1 | 0 | zaliczony |
| 50 | 137703.1 | 0 | 1 | 2 | 0 | zaliczony |
| 100 | 68308.3 | 1 | 4 | 7 | 0 | zaliczony |
| 200 | 81789.6 | 2 | 5 | 7 | 0 | zaliczony |
| 400 | 57472.9 | 4 | 14 | 15 | 0 | zaliczony |

## Wnioski automatyczne

- Maksymalna zmierzona przepustowość: **139791.7 RPS** przy konkurencji 25.
- Najwyższa konkurencja spełniająca kryterium (p95 < 400 ms, 0 błędów): **400**.
- W całym zakresie testu nie wystąpił ani jeden błąd.
- Przepustowość przy najwyższej konkurencji spadła o 59% względem maksimum - system jest za punktem załamania.

## Zalecenia

1. Za pojemność operacyjną przyjmij konkurencję o jeden poziom niższą od najwyższej zaliczonej.
2. Powtórz pomiar trzykrotnie i porównaj mediany, zanim uznasz wynik za wiążący.
3. Przed zmianą konfiguracji zapisz obecne wartości jako punkt odniesienia (baseline).

## Opis środowiska testowego
- **Wersja Nginx**: nginx version: nginx/1.28.3 (Ubuntu)
- **Wersja ApacheBench**: This is ApacheBench, Version 2.3 <$Revision: 1923142 $>
- **Zasoby sprzętowe**: 14 rdzeni CPU, 31Gi RAM
- **Połączenie generatora z SUT**: test wykonany lokalnie przez pętlę zwrotną (localhost)
- **Uwaga o medianie**: Raport wygenerowany dla przebiegu środkowego (mediany: `wyniki-20261119-171700.csv`) z trzech wykonanych pomiarów.
