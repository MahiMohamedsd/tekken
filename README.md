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

## Organizer login

Only the organizer can record or delete results. Anyone can still view the standings and register a fighter.

1. In Supabase, open **SQL Editor**, paste `admin.sql`, and run it.
2. Open **Authentication → Users → Add user → Create new user**:
   - Email: `admin123@tekken.local`
   - Password: the organizer password
   - Tick **Auto Confirm User**
3. On the page, sign in with username `admin123` and that password. The page adds `@tekken.local` for you.

Optional: turn off **Authentication → Sign In / Providers → Allow new users to sign up** so nobody else can create accounts. Other accounts can't record results anyway, because the policies only accept `admin123@tekken.local`.

`claude-artifact.html` is the original claude.ai artifact version, which stores data in the artifact instead of Supabase.
