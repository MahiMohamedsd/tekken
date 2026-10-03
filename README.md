# War for the Crown · Tekken 8 tournament

Register fighters, record match scores, and follow a live leaderboard that uses the tournament's points system.

## Hook it up to Supabase

1. Create a project at supabase.com.
2. Open **SQL Editor**, paste `schema.sql`, and run it.
3. Open **Project Settings → API** and copy the **Project URL** and the **anon public** key.
4. Paste both into the top of the script in `index.html`:
   ```js
   const SUPABASE_URL = "https://xxxx.supabase.co";
   const SUPABASE_ANON_KEY = "eyJ...";
   ```
5. Host `index.html` anywhere static: GitHub Pages, Netlify Drop, or Vercel. Opening it locally also works.

The anon key is meant to be public. Anyone with the page link can add and delete scores, so only share it with the people in the tournament.

`claude-artifact.html` is the original claude.ai artifact version, which stores data in the artifact instead of Supabase.
