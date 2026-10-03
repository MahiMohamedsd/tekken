-- Champion select: each fighter picks 3 champions and bans 1; the organizer can add extra bans and lock the draft.
-- Run in Supabase > SQL Editor AFTER schema.sql and admin.sql (safe to run more than once).

create table if not exists public.settings (
  id            text primary key,
  bans          text[] not null default '{}',
  draft_locked  boolean not null default false
);
insert into public.settings (id) values ('main') on conflict (id) do nothing;

create table if not exists public.drafts (
  player_id   text primary key references public.players(id) on delete cascade,
  picks       text[] not null default '{}' check (cardinality(picks) <= 3),
  ban         text,
  updated_at  bigint not null default (extract(epoch from now()) * 1000)::bigint
);

create or replace function public.draft_open() returns boolean
language sql stable as $$
  select public.is_organizer() or not coalesce((select draft_locked from public.settings where id = 'main'), false)
$$;

alter table public.settings enable row level security;
alter table public.drafts enable row level security;

drop policy if exists "settings read"      on public.settings;
drop policy if exists "settings organizer" on public.settings;
drop policy if exists "drafts read"        on public.drafts;
drop policy if exists "drafts insert"      on public.drafts;
drop policy if exists "drafts update"      on public.drafts;
drop policy if exists "drafts remove"      on public.drafts;

create policy "settings read"      on public.settings for select to anon, authenticated using (true);
create policy "settings organizer" on public.settings for all to authenticated
  using (public.is_organizer()) with check (public.is_organizer());

create policy "drafts read"   on public.drafts for select to anon, authenticated using (true);
create policy "drafts insert" on public.drafts for insert to anon, authenticated with check (public.draft_open());
create policy "drafts update" on public.drafts for update to anon, authenticated using (public.draft_open()) with check (public.draft_open());
create policy "drafts remove" on public.drafts for delete to authenticated using (public.is_organizer());

do $$ begin
  alter publication supabase_realtime add table public.settings, public.drafts;
exception when duplicate_object then null; end $$;
