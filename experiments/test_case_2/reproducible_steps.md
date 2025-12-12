### Title
Remote Cache Persistence Under Network Failure

#### Description
- Client-side file location: `./toutcas/lib/src/views/home_view.dart` (line 433)
- Server-side file location: `./toutcas/server/routes/burn_after_use.py`

#### Steps
- 1. Run this Flutter application
- 2. Run Python+Flask server side by the command `python3 app.py` in the root directory of server
- 3. Choose a PDF file to chat with in client side
- 4. Click `Burn` button to eliminate the local data cache and the remote cache
- 5. Repeat 15 times on the Step 3 and Step 4 separately on macOS and Windows

#### Results
After running 15 times of burning local cache and 15 times of burning remote cache, we got two results as shown below:
- Result 1 on client-side:
  - Failed 2 times, including: local network error and weak connection occurring timeout
- Result 2 on server-side:
  - Failed 2 times, including: Python Flask crashed and the cache file is locked due to another process uses it

