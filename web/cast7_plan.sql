-- =====================================================================
--  ZOZ Trenažér – část 7: plán přípravy do ZOZ se ukládá k účtu
--  (datum ZOZ, denní čas a stav opakování každé otázky – přenáší se
--  mezi mobilem a počítačem). Spustit jednou v SQL editoru.
--  Opakované spuštění nevadí. Bez něj plán funguje jen v zařízení.
-- =====================================================================
alter table public.profiles add column if not exists plan jsonb;

-- kontrola
select id, email, (plan is not null) as ma_plan from public.profiles order by created_at desc limit 5;
