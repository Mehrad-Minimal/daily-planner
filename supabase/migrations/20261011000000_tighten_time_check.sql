-- The original check accepted impossible times such as 25:00 or 12:99.
-- Only 00:00 to 23:59 is valid. Existing rows that fail this check will block the migration.
alter table public.tasks drop constraint if exists tasks_time_check;
alter table public.tasks add constraint tasks_time_check
  check (time is null or time ~ '^([01][0-9]|2[0-3]):[0-5][0-9]$');
