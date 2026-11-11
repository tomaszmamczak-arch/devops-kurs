#!/bin/bash

set -euo pipefail

PROG=85
VERBOSE=0

usage() {
    echo "Użycie: ${0##*/} [-p PROCENT] [-v] [-h]"
}

while getopts ":p:vh" opcja; do
    case "$opcja" in
        p) PROG="$OPTARG" ;;
        v) VERBOSE=1 ;;
        h) usage; exit 0 ;;
        :) echo "Opcja -$OPTARG wymaga wartości" >&2; exit 2 ;;
        \?) echo "Nieznana opcja: -$OPTARG" >&2; exit 2 ;;
    esac
done
shift $((OPTIND - 1))

if [[ ! "$PROG" =~ ^[0-9]+$ ]]; then
    echo "Błąd: próg musi być liczbą całkowitą: $PROG" >&2
    exit 2
fi

przekroczono=0

while read -r fs procent zamontowano; do
    wartosc="${procent%\%}"

    if (( wartosc >= PROG )); then
        echo "[WARN] Przekroczono próg (${wartosc}% >= ${PROG}%): $fs na $zamontowano" >&2
        przekroczono=1
    elif (( VERBOSE )); then
        echo "[INFO] OK (${wartosc}% < ${PROG}%): $fs na $zamontowano" >&2
    fi
done < <(df -P | awk 'NR > 1 {print $1, $5, $6}')

exit "$przekroczono"
