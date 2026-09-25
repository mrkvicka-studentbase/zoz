-- =====================================================================
--  OPRAVA: nastavení prvního admina
--
--  Původní pojistka proti tomu, aby si uživatel sám nastavil is_admin,
--  blokovala i SQL editor (ten běží bez přihlášeného uživatele, takže
--  ho trigger vyhodnotil jako „nemá práva" a změnu vrátil zpátky).
--
--  Spusť celé najednou: SQL Editor → New query → Run.
--  Na řádku s UPDATE si nejdřív uprav e-mail!
-- =====================================================================

-- 1) oprava pojistky
create or replace function public.protect_admin_flag()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.is_admin is distinct from old.is_admin then
    -- Kontrola se uplatní jen na požadavky přihlášeného uživatele přes API.
    -- Ze SQL editoru (auth.uid() je NULL) projde vždy.
    if auth.uid() is not null
       and not exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin) then
      new.is_admin := old.is_admin;
    end if;
  end if;
  return new;
end;
$$;

-- 2) nastav sebe jako admina  ← UPRAV E-MAIL
update public.profiles
set is_admin = true
where lower(email) = lower('tvuj@email.cz');

-- 3) kontrola – v tabulce dole musí být u tvého e-mailu is_admin = true
select email, display_name, is_admin, created_at
from public.profiles
order by created_at;
