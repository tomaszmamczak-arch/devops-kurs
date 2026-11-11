#!/usr/bin/env bash

katalog="${1:?Podaj katalog}"

if [[ ! -d "$katalog" ]]; then
    echo "Nie znaleziono katalogu: $katalog" >&2
    exit 1
fi

declare -A statystyka

for plik in "$katalog"/*; do
    [[ -f "$plik" ]] || continue

    nazwa="${plik##*/}"

    if [[ "$nazwa" == *.* ]]; then
        rozsz="${nazwa##*.}"
    else
        rozsz="(brak)"
    fi

    statystyka[$rozsz]=$(( ${statystyka[$rozsz]:-0} + 1 ))
done

for r in "${!statystyka[@]}"; do
    printf '%-10s %d\n' "$r" "${statystyka[$r]}"
done | sort -k2 -nr

echo "---"
echo "Liczba plików:    $(find "$katalog" -type f | wc -l)"
echo "Liczba katalogów: $(find "$katalog" -type d | wc -l)"
echo "Największy plik:  $(ls -Sh "$katalog" | head -n 1)"
