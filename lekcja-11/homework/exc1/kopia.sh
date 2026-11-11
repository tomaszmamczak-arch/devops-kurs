#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "Użycie: ${0##*/} <katalog-źródłowy> [katalog-docelowy]" >&2
    exit 2
fi

zrodlo="$1"
cel="${2:-$HOME/kopie}"

if [[ ! -d "$zrodlo" ]]; then
    echo "Błąd: $zrodlo nie jest katalogiem" >&2
    exit 1
fi

mkdir -p "$cel"

nazwa="${zrodlo##*/}"
data=$(date +%Y-%m-%d-%H%M)
archiwum="$cel/$nazwa-$data.tar.gz"

tar -czf "$archiwum" -C "$zrodlo" .
tar -tzf "$archiwum" >/dev/null

echo "Utworzono: $archiwum"
du -sh "$archiwum" | cut -f1
