# Dziennik strojenia Nginksa

## Wpis 1: Podniesienie worker_connections (768 -> 8192) i LimitNOFILE (65535)
- **Co zmieniono**: Ustawiono `worker_connections 8192`, `multi_accept on`, `worker_rlimit_nofile 65535` w `/etc/nginx/nginx.conf` oraz `LimitNOFILE=65535` w `systemctl edit nginx`.
- **Dlaczego**: Domyślne 768 połączeń na proces roboczy stanowi niski sufit pod dużym obciążeniem (szczególnie w trybie reverse proxy, gdzie każde żądanie zużywa 2 deskryptory).
- **Metryki PRZED (baseline)**: RPS: 88539.45 | p95: 3 ms | p99: 3 ms | błędy: 0%
- **Metryki PO**: RPS: 119334.59 | p95: 2 ms | p99: 2 ms | błędy: 0%
- **Wniosek**: Zauważalny wzrost RPS (o ok. 35%) oraz spadek p95/p99 z 3 ms do 2 ms przy włączonym `multi_accept on` (worker przyjmuje wiele nowych połączeń naraz w jednej iteracji pętli zdarzeń).

## Wpis 2: Włączenie kompresji gzip (poziom 4)
- **Co zmieniono**: Włączono `gzip on;`, `gzip_comp_level 4;`, `gzip_min_length 1024;` oraz `gzip_types` w kontekście `http` w `/etc/nginx/nginx.conf`.
- **Dlaczego**: Zmniejszenie rozmiaru przesyłanych odpowiedzi tekstowych (HTML, CSS, JSON, JS) skraca czas transferu sieciowego.
- **Metryki PRZED**: RPS: 119334.59 | p95: 2 ms | p99: 2 ms | błędy: 0%
- **Metryki PO**: RPS: 106170.64 | p95: 2 ms | p99: 3 ms | błędy: 0%
- **Wniosek**: **Zmiana nie przyniosła poprawy** – dla małej strony testowej (615 bajtów, poniżej progu `gzip_min_length 1024`) testowanej lokalnie przez `localhost` kompresja nie daje oszczędności na transferze sieciowym, a narzut przetwarzania lekko obniżył maksymalny RPS (szum/koszt CPU).

## Wpis 3: Zwiększenie kolejki akceptacji połączeń (somaxconn i backlog=16384)
- **Co zmieniono**: Ustawiono `net.core.somaxconn=16384` w jądrze systemu oraz `listen 80 default_server backlog=16384;` w konfiguracji virtual hosta.
- **Dlaczego**: Zabezpieczenie kolejki nasłuchu jądra przed przepełnieniem i odrzucaniem pakietów (`ListenOverflows`) przy nagłych skokach nowych połączeń.
- **Metryki PRZED**: RPS: 106170.64 | p95: 2 ms | p99: 3 ms | błędy: 0%
- **Metryki PO**: RPS: 92164.20 | p95: 4 ms | p99: 4 ms | błędy: 0%
- **Wniosek**: **Zmiana nie przyniosła poprawy** w teście ze stałym połączeniem (`ab -k` utrzymuje 100 połączeń keep-alive zamiast otwierać tysiące nowych gniazd naraz). Kolejka nasłuchu jest zabezpieczona na wypadek nagłych skoków ruchu, natomiast w bieżącym profilu testu nie była wąskim gardłem.
