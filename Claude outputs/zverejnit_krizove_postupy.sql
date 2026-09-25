-- =====================================================================
--  ZOZ Trenažér – ZVEŘEJNIT krizové postupy pro všechny uživatele
--  Spusť, až budeš s postupy spokojený. Aplikaci měnit nemusíš.
-- =====================================================================
insert into public.app_meta(key, value) values ('krize_verejne', 'true')
  on conflict (key) do update set value = 'true';

-- změna verze obsahu → všem se při dalším otevření stáhne obsah znovu i s postupy
update public.app_meta set value = value || '-krize' where key = 'content_version';

select key, value from public.app_meta order by key;

-- Zpátky jen pro admina:
--   update public.app_meta set value = 'false' where key = 'krize_verejne';
--   update public.app_meta set value = value || '-x' where key = 'content_version';
