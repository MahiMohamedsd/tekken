-- Organizer-only results.
-- Run this in Supabase > SQL Editor AFTER schema.sql (safe to run more than once).
-- Everyone can read. Anyone can register a fighter.
-- Only the organizer account (admin123@tekken.local) can record, delete or remove.

create or replace function public.is_organizer() returns boolean
language sql stable as $$
  select coalesce(auth.jwt() ->> 'email', '') = 'admin123@tekken.local'
$$;

drop policy if exists "players open"      on public.players;
drop policy if exists "matches open"      on public.matches;
drop policy if exists "players read"      on public.players;
drop policy if exists "players register"  on public.players;
drop policy if exists "players organizer" on public.players;
drop policy if exists "players remove"    on public.players;
drop policy if exists "matches read"      on public.matches;
drop policy if exists "matches organizer" on public.matches;

create policy "players read"     on public.players for select to anon, authenticated using (true);
create policy "players register" on public.players for insert to anon, authenticated with check (true);
create policy "players organizer" on public.players for update to authenticated using (public.is_organizer()) with check (public.is_organizer());
create policy "players remove"   on public.players for delete to authenticated using (public.is_organizer());

create policy "matches read"      on public.matches for select to anon, authenticated using (true);
create policy "matches organizer" on public.matches for all to authenticated
  using (public.is_organizer()) with check (public.is_organizer());
