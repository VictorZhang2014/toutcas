### Title
Local Cache Deletion Failure Under Software Crash

#### Description
- File location: `./toutcas/lib/src/views/home_view.dart`
- Method in line of : 412

#### Steps
- 1. Run this Flutter application
- 2. Choose a PDF file to chat with
- 3. Click `Burn` button to eliminate the local data cache 
- 4. Repeat 15 times on the Step 2 and Step 3 

#### Results
After running 15 times of burning local cache separately on macOS and Windows, we got two results from the OS-level:
- Result 1 on macOS:
  - Failed once due to I inserted the code `throws Exception('An intentional crash');` in line of 421 while the ToutCas app was trying to eliminate the cache through the dart code.
- Result 2 on Windows OS:
  - Two times failed due to I was opening 2 files while the ToutCas app was trying to eliminate the cache through the dart code.

