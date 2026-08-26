-- TOEFL Sentence Review: one private progress row per signed-in user.
-- Run this entire file once in Supabase Dashboard > SQL Editor.

create table if not exists public.sentence_review_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.sentence_review_progress enable row level security;

drop policy if exists "Users can read their own sentence progress" on public.sentence_review_progress;
create policy "Users can read their own sentence progress"
on public.sentence_review_progress
for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Users can create their own sentence progress" on public.sentence_review_progress;
create policy "Users can create their own sentence progress"
on public.sentence_review_progress
for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update their own sentence progress" on public.sentence_review_progress;
create policy "Users can update their own sentence progress"
on public.sentence_review_progress
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

grant usage on schema public to authenticated;
grant select, insert, update on table public.sentence_review_progress to authenticated;

