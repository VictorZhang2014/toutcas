# Table 1 shows the latency

| Operation                      | Mean Latency (ms)| Runs |
|--------------------------------|------------------|------|
| Tenant Query Session           | 7285.12 ms       | 30   |
| Burn-After-Use Local Cleanup   | 2.87 ms          | 30   |
| Remote Cache Invalidation      | 2.42 ms          | 30   |


# Table 2 shows every log item

| Run | Tenant Query Session (ms)| BAU Local Cleanup (ms) | Remote Cache Invalidation (ms) |
|-----|--------------------------|------------------------|--------------------------------|
| 1   | 6903.50                  | 4                      | 2.49                           |
| 2   | 6657.23                  | 3                      | 2.08                           |
| 3   | 8413.94                  | 2                      | 2.94                           |
| 4   | 8310.93                  | 2                      | 1.23                           |
| 5   | 8336.03                  | 1                      | 1.11                           |
| 6   | 6452.68                  | 2                      | 1.80                           |
| 7   | 6598.69                  | 3                      | 1.13                           |
| 8   | 32292.82                 | 11                     | 2.65                           |
| 9   | 3096.51                  | 23                     | 1.39                           |
| 10  | 1238.34                  | 2                      | 1.94                           |
| 11  | 9180.47                  | 4                      | 1.03                           |
| 12  | 5363.54                  | 1                      | 2.93                           |
| 13  | 9845.61                  | 1                      | 1.55                           |
| 14  | 3635.48                  | 1                      | 2.35                           |
| 15  | 1039.84                  | 1                      | 1.93                           |
| 16  | 1474.25                  | 1                      | 1.64                           |
| 17  | 5872.54                  | 1                      | 1.08                           |
| 18  | 9480.56                  | 1                      | 2.85                           |
| 19  | 9768.89                  | 1                      | 4.26                           |
| 20  | 8509.64                  | 2                      | 1.16                           |
| 21  | 2846.47                  | 1                      | 2.37                           |
| 22  | 7527.58                  | 2                      | 5.78                           |
| 23  | 6015.01                  | 1                      | 3.32                           |
| 24  | 6611.92                  | 1                      | 2.29                           |
| 25  | 7369.00                  | 1                      | 1.71                           |
| 26  | 5948.14                  | 3                      | 4.14                           |
| 27  | 12786.95                 | 3                      | 4.50                           |
| 28  | 1078.05                  | 1                      | 1.47                           |
| 29  | 5344.24                  | 2                      | 3.55                           |
| 30  | 9056.01                  | 2                      | 2.50                           |


# Complete logs below
**Combined the server side logs and flutter side logs manually**

Run 1:
2026-05-02 20:01:44 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:01:37.558411 | end=2026-05-02T20:01:44.461996 | latency=6903.50 ms
2026-05-02 20:02:00 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:02:00] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:02:05.222997 | end=2026-05-02T20:02:05.227977 | latency=4 ms
2026-05-02 20:02:05 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:02:05.252414 | end=2026-05-02T20:02:05.254923 | latency=2.49 ms
2026-05-02 20:02:05 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:02:05] "POST /burn_after_use HTTP/1.1" 200 -

Run 2:
2026-05-02 20:04:00 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:03:53.606070 | end=2026-05-02T20:04:00.263465 | latency=6657.23 ms
2026-05-02 20:04:28 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:04:28] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:04:38.538804 | end=2026-05-02T20:04:38.541964 | latency=3 ms
2026-05-02 20:04:38 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:04:38.564284 | end=2026-05-02T20:04:38.566373 | latency=2.08 ms
2026-05-02 20:04:38 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:04:38] "POST /burn_after_use HTTP/1.1" 200 -

Run 3:
2026-05-02 20:05:34 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:05:26.477792 | end=2026-05-02T20:05:34.891824 | latency=8413.94 ms
2026-05-02 20:06:07 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:06:07] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:06:20.445450 | end=2026-05-02T20:06:20.448280 | latency=2 ms
2026-05-02 20:06:20 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:06:20.459459 | end=2026-05-02T20:06:20.462428 | latency=2.94 ms
2026-05-02 20:06:20 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:06:20] "POST /burn_after_use HTTP/1.1" 200 -

Run 4:
2026-05-02 20:07:09 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:07:00.860477 | end=2026-05-02T20:07:09.171663 | latency=8310.93 ms
2026-05-02 20:07:25 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:07:25] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:07:36.433353 | end=2026-05-02T20:07:36.435505 | latency=2 ms
2026-05-02 20:07:36 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:07:36.440874 | end=2026-05-02T20:07:36.442127 | latency=1.23 ms
2026-05-02 20:07:36 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:07:36] "POST /burn_after_use HTTP/1.1" 200 -

Run 5:
2026-05-02 20:08:21 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:08:13.596956 | end=2026-05-02T20:08:21.933073 | latency=8336.03 ms
2026-05-02 20:08:43 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:08:43] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:08:53.420753 | end=2026-05-02T20:08:53.422532 | latency=1 ms
2026-05-02 20:08:53 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:08:53.425140 | end=2026-05-02T20:08:53.426264 | latency=1.11 ms
2026-05-02 20:08:53 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:08:53] "POST /burn_after_use HTTP/1.1" 200 -

Run 6:
2026-05-02 20:09:45 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:09:39.313841 | end=2026-05-02T20:09:45.766991 | latency=6452.68 ms
2026-05-02 20:09:49 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:09:49] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:09:55.777250 | end=2026-05-02T20:09:55.778211 | latency=2 ms
2026-05-02 20:09:55 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:09:55.782635 | end=2026-05-02T20:09:55.784444 | latency=1.80 ms
2026-05-02 20:09:55 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:09:55] "POST /burn_after_use HTTP/1.1" 200 -

Run 7:
2026-05-02 20:10:59 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:10:52.828543 | end=2026-05-02T20:10:59.427329 | latency=6598.69 ms
2026-05-02 20:11:03 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:11:03] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:11:19.890126 | end=2026-05-02T20:11:19.893367 | latency=3 ms
2026-05-02 20:11:19 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:11:19.897097 | end=2026-05-02T20:11:19.898238 | latency=1.13 ms
2026-05-02 20:11:19 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:11:19] "POST /burn_after_use HTTP/1.1" 200 -

Run 8:
2026-05-02 20:12:36 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:12:04.330520 | end=2026-05-02T20:12:36.623473 | latency=32292.82 ms
2026-05-02 20:12:42 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:12:42] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:13:00.243993 | end=2026-05-02T20:13:00.255640 | latency=11 ms
2026-05-02 20:13:00 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:13:00.263013 | end=2026-05-02T20:13:00.265751 | latency=2.65 ms
2026-05-02 20:13:00 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:13:00] "POST /burn_after_use HTTP/1.1" 200 -

Run 9:
2026-05-02 20:13:40 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:13:37.140757 | end=2026-05-02T20:13:40.237350 | latency=3096.51 ms
2026-05-02 20:13:43 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:13:43] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:13:59.478510 | end=2026-05-02T20:13:59.502053 | latency=23 ms
2026-05-02 20:13:59 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:13:59.512409 | end=2026-05-02T20:13:59.513856 | latency=1.39 ms
2026-05-02 20:13:59 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:13:59] "POST /burn_after_use HTTP/1.1" 200 -

Run 10:
2026-05-02 20:14:46 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:14:45.556087 | end=2026-05-02T20:14:46.794598 | latency=1238.34 ms
2026-05-02 20:14:50 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:14:50] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:15:00.531863 | end=2026-05-02T20:15:00.534014 | latency=2 ms
2026-05-02 20:15:00 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:15:00.548768 | end=2026-05-02T20:15:00.550830 | latency=1.94 ms
2026-05-02 20:15:00 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:15:00] "POST /burn_after_use HTTP/1.1" 200 -

Run 11:
2026-05-02 20:20:24 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:18:39.024613 | end=2026-05-02T20:20:24.205449 | latency=9180.47 ms
2026-05-02 20:20:29 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:20:29] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:20:56.877540 | end=2026-05-02T20:20:56.882171 | latency=4 ms
2026-05-02 20:20:56 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:20:56.907427 | end=2026-05-02T20:20:56.908486 | latency=1.03 ms
2026-05-02 20:20:56 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:20:56] "POST /burn_after_use HTTP/1.1" 200 -

Run 12:
2026-05-02 20:22:26 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:22:21.215259 | end=2026-05-02T20:22:26.579004 | latency=5363.54 ms
2026-05-02 20:22:31 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:22:31] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:22:58.028386 | end=2026-05-02T20:22:58.029545 | latency=1 ms
2026-05-02 20:22:58 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:22:58.047090 | end=2026-05-02T20:22:58.050179 | latency=2.93 ms
2026-05-02 20:22:58 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:22:58] "POST /burn_after_use HTTP/1.1" 200 -

Run 13:
2026-05-02 20:23:47 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:23:37.769173 | end=2026-05-02T20:23:47.614830 | latency=9845.61 ms
2026-05-02 20:23:52 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:23:52] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:24:03.000148 | end=2026-05-02T20:24:03.001773 | latency=1 ms
2026-05-02 20:24:03 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:24:03.020535 | end=2026-05-02T20:24:03.022129 | latency=1.55 ms
2026-05-02 20:24:03 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:24:03] "POST /burn_after_use HTTP/1.1" 200 -

Run 14:
2026-05-02 20:24:45 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:24:41.548843 | end=2026-05-02T20:24:45.184360 | latency=3635.48 ms
2026-05-02 20:24:49 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:24:49] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:25:11.542680 | end=2026-05-02T20:25:11.544189 | latency=1 ms
2026-05-02 20:25:11 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:25:11.567460 | end=2026-05-02T20:25:11.569868 | latency=2.35 ms
2026-05-02 20:25:11 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:25:11] "POST /burn_after_use HTTP/1.1" 200 -

Run 15:
2026-05-02 20:25:44 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:25:43.577397 | end=2026-05-02T20:25:44.617265 | latency=1039.84 ms
2026-05-02 20:25:50 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:25:50] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:26:09.239014 | end=2026-05-02T20:26:09.240680 | latency=1 ms
2026-05-02 20:26:09 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:26:09.244224 | end=2026-05-02T20:26:09.246173 | latency=1.93 ms
2026-05-02 20:26:09 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:26:09] "POST /burn_after_use HTTP/1.1" 200 -

Run 16:
2026-05-02 20:26:42 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:26:41.251626 | end=2026-05-02T20:26:42.725952 | latency=1474.25 ms
2026-05-02 20:26:49 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:26:49] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:27:00.646821 | end=2026-05-02T20:27:00.648163 | latency=1 ms
2026-05-02 20:27:00 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:27:00.659497 | end=2026-05-02T20:27:00.661263 | latency=1.64 ms
2026-05-02 20:27:00 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:27:00] "POST /burn_after_use HTTP/1.1" 200 -

Run 17:
2026-05-02 20:28:21 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:28:15.960225 | end=2026-05-02T20:28:21.832848 | latency=5872.54 ms
2026-05-02 20:28:27 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:28:27] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:28:36.681739 | end=2026-05-02T20:28:36.682436 | latency=1 ms
2026-05-02 20:28:36 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:28:36.685776 | end=2026-05-02T20:28:36.686892 | latency=1.08 ms
2026-05-02 20:28:36 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:28:36] "POST /burn_after_use HTTP/1.1" 200 -

Run 18:
2026-05-02 20:29:36 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:29:27.301718 | end=2026-05-02T20:29:36.782500 | latency=9480.56 ms
2026-05-02 20:29:42 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:29:42] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:30:14.701646 | end=2026-05-02T20:30:14.703590 | latency=1 ms
2026-05-02 20:30:14 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:30:14.710988 | end=2026-05-02T20:30:14.713933 | latency=2.85 ms
2026-05-02 20:30:14 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:30:14] "POST /burn_after_use HTTP/1.1" 200 -

Run 19:
2026-05-02 20:31:08 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:30:58.244045 | end=2026-05-02T20:31:08.017346 | latency=9768.89 ms
2026-05-02 20:31:19 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:31:19] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:31:45.360133 | end=2026-05-02T20:31:45.362101 | latency=1 ms
2026-05-02 20:31:45 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:31:45.371526 | end=2026-05-02T20:31:45.375930 | latency=4.26 ms
2026-05-02 20:31:45 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:31:45] "POST /burn_after_use HTTP/1.1" 200 -

Run 20:
2026-05-02 20:32:53 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:32:44.504572 | end=2026-05-02T20:32:53.014332 | latency=8509.64 ms
2026-05-02 20:33:00 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:33:00] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:33:10.340751 | end=2026-05-02T20:33:10.343276 | latency=2 ms
2026-05-02 20:33:10 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:33:10.351424 | end=2026-05-02T20:33:10.352593 | latency=1.16 ms
2026-05-02 20:33:10 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:33:10] "POST /burn_after_use HTTP/1.1" 200 -

Run 21:
2026-05-02 20:34:24 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:34:21.552636 | end=2026-05-02T20:34:24.399177 | latency=2846.47 ms
2026-05-02 20:34:38 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:34:38] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:35:13.604525 | end=2026-05-02T20:35:13.605670 | latency=1 ms
2026-05-02 20:35:13 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:35:13.632952 | end=2026-05-02T20:35:13.635343 | latency=2.37 ms
2026-05-02 20:35:13 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:35:13] "POST /burn_after_use HTTP/1.1" 200 -

Run 22:
2026-05-02 20:36:08 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:36:01.270804 | end=2026-05-02T20:36:08.798485 | latency=7527.58 ms
2026-05-02 20:36:23 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:36:23] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:36:39.796475 | end=2026-05-02T20:36:39.799061 | latency=2 ms
2026-05-02 20:36:39 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:36:39.804534 | end=2026-05-02T20:36:39.810343 | latency=5.78 ms
2026-05-02 20:36:39 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:36:39] "POST /burn_after_use HTTP/1.1" 200 -

Run 23:
2026-05-02 20:38:13 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:38:07.496827 | end=2026-05-02T20:38:13.511938 | latency=6015.01 ms
2026-05-02 20:38:38 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:38:38] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:39:30.538113 | end=2026-05-02T20:39:30.538777 | latency=1 ms
2026-05-02 20:39:30 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:39:30.542872 | end=2026-05-02T20:39:30.546210 | latency=3.32 ms
2026-05-02 20:39:30 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:39:30] "POST /burn_after_use HTTP/1.1" 200 -

Run 24:
2026-05-02 20:41:07 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:41:00.790691 | end=2026-05-02T20:41:07.402749 | latency=6611.92 ms
2026-05-02 20:41:15 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:41:15] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:42:02.217704 | end=2026-05-02T20:42:02.219260 | latency=1 ms
2026-05-02 20:42:02 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:42:02.237631 | end=2026-05-02T20:42:02.240028 | latency=2.29 ms
2026-05-02 20:42:02 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:42:02] "POST /burn_after_use HTTP/1.1" 200 -

Run 25:
2026-05-02 20:42:56 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:42:49.138903 | end=2026-05-02T20:42:56.508109 | latency=7369.00 ms
2026-05-02 20:43:11 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:43:11] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:43:57.973894 | end=2026-05-02T20:43:57.975870 | latency=1 ms
2026-05-02 20:43:57 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:43:57.982307 | end=2026-05-02T20:43:57.984075 | latency=1.71 ms
2026-05-02 20:43:57 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:43:57] "POST /burn_after_use HTTP/1.1" 200 -

Run 26:
2026-05-02 20:44:47 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:44:41.637536 | end=2026-05-02T20:44:47.585775 | latency=5948.14 ms
2026-05-02 20:45:18 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:45:18] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:46:43.367810 | end=2026-05-02T20:46:43.371060 | latency=3 ms
2026-05-02 20:46:43 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:46:43.378524 | end=2026-05-02T20:46:43.382759 | latency=4.14 ms
2026-05-02 20:46:43 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:46:43] "POST /burn_after_use HTTP/1.1" 200 -

Run 27:
2026-05-02 20:47:59 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:47:26.604159 | end=2026-05-02T20:47:59.391378 | latency=12786.95 ms
2026-05-02 20:48:06 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:48:06] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:48:18.434105 | end=2026-05-02T20:48:18.437568 | latency=3 ms
2026-05-02 20:48:18 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:48:18.453907 | end=2026-05-02T20:48:18.458430 | latency=4.50 ms
2026-05-02 20:48:18 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:48:18] "POST /burn_after_use HTTP/1.1" 200 -

Run 28:
2026-05-02 20:48:59 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:48:58.585718 | end=2026-05-02T20:48:59.663892 | latency=1078.05 ms
2026-05-02 20:49:05 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:49:05] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:49:25.847638 | end=2026-05-02T20:49:25.848185 | latency=1 ms
2026-05-02 20:49:25 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:49:25.850839 | end=2026-05-02T20:49:25.852334 | latency=1.47 ms
2026-05-02 20:49:25 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:49:25] "POST /burn_after_use HTTP/1.1" 200 -

Run 29:
2026-05-02 20:50:21 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:50:16.325336 | end=2026-05-02T20:50:21.669837 | latency=5344.24 ms
2026-05-02 20:50:28 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:50:28] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:50:44.082069 | end=2026-05-02T20:50:44.084632 | latency=2 ms
2026-05-02 20:50:44 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:50:44.103130 | end=2026-05-02T20:50:44.106888 | latency=3.55 ms
2026-05-02 20:50:44 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:50:44] "POST /burn_after_use HTTP/1.1" 200 -

Run 30:
2026-05-02 20:51:58 [INFO] app - TENANT_QUERY_SESSION | start=2026-05-02T20:51:28.397908 | end=2026-05-02T20:51:58.454194 | latency=9056.01 ms
2026-05-02 20:52:02 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:52:02] "POST /pdf_analyzer HTTP/1.1" 200 -
flutter: BURN_AFTER_USE_LOCAL_CLEANUP | start=2026-05-02T20:52:14.903851 | end=2026-05-02T20:52:14.906552 | latency=2 ms
2026-05-02 20:52:14 [INFO] app - REMOTE_CACHE_INVALIDATION | start=2026-05-02T20:52:14.911701 | end=2026-05-02T20:52:14.914227 | latency=2.50 ms
2026-05-02 20:52:14 [INFO] werkzeug - 127.0.0.1 - - [02/May/2026 20:52:14] "POST /burn_after_use HTTP/1.1" 200 -
