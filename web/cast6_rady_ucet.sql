-- =====================================================================
--  ZOZ Trenažér – část 6: výběr řad se ukládá k účtu (přenáší se mezi zařízeními)
--  Spustit jednou v SQL editoru. Opakované spuštění nevadí.
-- =====================================================================
alter table public.profiles add column if not exists rady jsonb;

-- kontrola
select id, email, rady from public.profiles order by created_at desc limit 5;
