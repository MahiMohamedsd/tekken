-- War for the Crown: Supabase schema
-- Paste this whole file into Supabase > SQL Editor > New query, then Run.

create table if not exists public.players (
  id         text primary key,
  name       text not null unique,
  main       text not null default '',
  joined_at  bigint not null default (extract(epoch from now()) * 1000)::bigint
);

create table if not exists public.matches (
  id     uuid primary key default gen_random_uuid(),
  p1     text not null references public.players(id),
  p2     text not null references public.players(id),
  r1     int  not null check (r1 between 0 and 3),
  r2     int  not null check (r2 between 0 and 3),
  ex1    boolean not null default false,
  ex2    boolean not null default false,
  stage  text not null default 'group' check (stage in ('group', 'final')),
  ts     bigint not null default (extract(epoch from now()) * 1000)::bigint,
  check (p1 <> p2)
);

-- Anyone with the link can read and write (it's a friends tournament, no logins).
alter table public.players enable row level security;
alter table public.matches enable row level security;

drop policy if exists "players open" on public.players;
create policy "players open" on public.players for all to anon, authenticated using (true) with check (true);
drop policy if exists "matches open" on public.matches;
create policy "matches open" on public.matches for all to anon, authenticated using (true) with check (true);

-- Live updates for everyone with the page open.
alter publication supabase_realtime add table public.players, public.matches;

-- The 5 fighters from the poster.
insert into public.players (id, name, joined_at) values
  ('aymen', 'AYMEN', 1), ('bito', 'BITO', 2), ('mahi', 'MAHI', 3), ('nembo', 'NEMBO', 4), ('ziad', 'ZIAD', 5)
on conflict (id) do nothing;
