### Title
Race-Condition Attack on BAU Burn Timer

#### Description
Such conditions include the macOS App Nap feature, Windows Suspend Process, system‑wide Low‑Power/Battery Saver Mode, extreme CPU overloading, or blocking I/O operations (e.g., processing a large file on the main thread). These situations temporarily stall the UI thread or main isolate, preventing scheduled timer events from firing at their intended time.

#### Steps
- 1. Run this Flutter application
- 2. Choose a PDF file, or load an internal web page on the ToutCas client
- 3. Freeze the UI
  - 3.1 Upload a 1GB file to block I/O operations
  - 3.2 Wait to active the low-power battery mode
- 4. Test the two modes in Step 3 to get two failure of burning-event, and operate eight normal procedures when using ToutCas.

#### Results
- Two tests freeze the UI, the timer was counting to zero, but the chat wasn't burned because of freezed
  - https://github.com/VictorZhang2014/toutcas/blob/main/experiments/case_study_4/results/FreezedUI.png
- Eight normal operation on ToutCas
