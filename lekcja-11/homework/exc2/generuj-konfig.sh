#!/usr/bin/env bash

srodowisko="${1:?Podaj środowisko: dev, stage albo prod}"

case "$srodowisko" in
    dev)
        host="localhost"
        port=8080
        ;;
    stage)
        host="stage.wewnetrzny.lan"
        port=8080
        ;;
    prod)
        host="prod.wewnetrzny.lan"
        port=443
        ;;
    *)
        echo "Nieznane środowisko: $srodowisko" >&2
        exit 2
        ;;
esac

cat > app.env <<EOF
# Wygenerowano: $(date +'%Y-%m-%d %H:%M')
SRODOWISKO=$srodowisko
HOST=$host
PORT=$port
EOF

cat > start.sh <<'EOF'
#!/usr/bin/env bash
source app.env
echo "Startuje $SRODOWISKO na porcie $PORT, argumenty: $@"
EOF

chmod +x start.sh
