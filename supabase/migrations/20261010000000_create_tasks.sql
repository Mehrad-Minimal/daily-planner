create table public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  day date not null,
  title text not null check (char_length(title) between 1 and 80),
  time text check (time is null or time ~ '^[0-2][0-9]:[0-5][0-9]$'),
  color text not null default 'blue' check (color in ('blue','green','orange','pink','purple')),
  done boolean not null default false,
  created_at timestamptz not null default now()
);

create index tasks_user_day_idx on public.tasks (user_id, day);

alter table public.tasks enable row level security;

create policy "Users read own tasks" on public.tasks
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "Users insert own tasks" on public.tasks
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Users update own tasks" on public.tasks
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "Users delete own tasks" on public.tasks
  for delete to authenticated using ((select auth.uid()) = user_id);
