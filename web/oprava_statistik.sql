-- =====================================================================
--  ZOZ Trenažér – oprava statistik  (část 4)
--
--  1) smaže zdvojené odpovědi, které vznikly chybou v odesílání
--  2) přidá pojistku, aby se stejná odpověď už nikdy neuložila dvakrát
--  3) začne zaznamenávat, na kterou ze tří možností se kliklo
--
--  Spustit jednou v SQL editoru. Opakované spuštění nevadí.
--  POZOR: nejdřív spusť tohle, teprve pak nahraj nový index.html.
-- =====================================================================

-- ---------- stav před opravou ----------
select 'před opravou' as stav,
       (select count(*) from public.attempts)  as odpovedi,
       (select count(*) from public.test_runs) as testy;


-- ---------- 1) odstranění duplicit ----------
-- Kopie jedné odpovědi jsou shodné včetně času vzniku (čas posílá prohlížeč,
-- takže všechny kopie mají stejný na milisekundu). Z každé skupiny zůstane
-- záznam s nejnižším id, zbytek jde pryč.

delete from public.attempts a
using public.attempts b
where a.user_id    = b.user_id
  and a.question_n = b.question_n
  and a.created_at = b.created_at
  and a.id > b.id;

delete from public.test_runs a
using public.test_runs b
where a.user_id    = b.user_id
  and a.created_at = b.created_at
  and a.id > b.id;


-- ---------- 2) pojistka proti opakovanému uložení ----------
-- Každá odpověď dostane v prohlížeči vlastní identifikátor. Když se odeslání
-- z jakéhokoli důvodu zopakuje (výpadek signálu, obnovení stránky), databáze
-- druhou kopii tiše zahodí.

alter table public.attempts  add column if not exists client_id uuid;
alter table public.test_runs add column if not exists client_id uuid;

create unique index if not exists attempts_client_idx  on public.attempts(client_id);
create unique index if not exists test_runs_client_idx on public.test_runs(client_id);

-- zápis probíhá přes „vlož, a když už tam je, nedělej nic“ – k tomu je potřeba
-- i právo update na vlastní řádky
drop policy if exists attempts_update on public.attempts;
create policy attempts_update on public.attempts
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists test_runs_update on public.test_runs;
create policy test_runs_update on public.test_runs
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());


-- ---------- 3) která ze tří možností byla zvolena ----------
-- 0 = správná odpověď, 1 = první distraktor, 2 = druhý distraktor.
-- U kartiček zůstává prázdné (nemají možnosti). U odpovědí uložených
-- před touhle opravou to taky zůstane prázdné – rozpad se začne plnit až teď.

alter table public.attempts add column if not exists chosen smallint;


-- ---------- 4) statistiky vracejí i rozpad možností ----------

drop function if exists public.my_question_stats();
create or replace function public.my_question_stats()
returns table (question_n int, ok int, bad int, c0 int, c1 int, c2 int)
language sql
stable
security invoker
set search_path = public
as $$
  select a.question_n,
         count(*) filter (where a.correct)::int,
         count(*) filter (where not a.correct)::int,
         count(*) filter (where a.chosen = 0)::int,
         count(*) filter (where a.chosen = 1)::int,
         count(*) filter (where a.chosen = 2)::int
  from public.attempts a
  where a.user_id = auth.uid()
  group by a.question_n;
$$;

drop function if exists public.admin_worst_questions(int,int);
create or replace function public.admin_worst_questions(lim int default 20, min_answers int default 5)
returns table (question_n int, tema text, predpis text, answers int, ok int, c0 int, c1 int, c2 int)
language sql
stable
security definer
set search_path = public
as $$
  select a.question_n,
         max(a.tema), max(a.predpis),
         count(*)::int,
         count(*) filter (where a.correct)::int,
         count(*) filter (where a.chosen = 0)::int,
         count(*) filter (where a.chosen = 1)::int,
         count(*) filter (where a.chosen = 2)::int
  from public.attempts a
  where public.is_admin()
  group by a.question_n
  having count(*) >= min_answers
  order by (count(*) filter (where a.correct))::numeric / count(*) asc, count(*) desc
  limit lim;
$$;

grant execute on function public.my_question_stats()            to authenticated;
grant execute on function public.admin_worst_questions(int,int) to authenticated;


-- ---------- stav po opravě ----------
select 'po opravě' as stav,
       (select count(*) from public.attempts)  as odpovedi,
       (select count(*) from public.test_runs) as testy;

-- Kontrola: tohle musí vrátit prázdný výsledek (žádné duplicity nezůstaly).
select user_id, question_n, created_at, count(*)
from public.attempts
group by user_id, question_n, created_at
having count(*) > 1;


-- =====================================================================
--  NEPOVINNÉ: úplné vynulování statistik
--  Když chceš začít s čistým štítem (doporučuju, protože odpovědi
--  z doby před opravou nemají zaznamenané možnosti), odkomentuj
--  následující dva řádky a spusť je zvlášť. Účty ani otázky to nesmaže.
-- =====================================================================
-- delete from public.attempts;
-- delete from public.test_runs;
