class CreateTriggerOnAddresses < ActiveRecord::Migration
  def self.up
    execute %{
      create or replace function set_address_info() \
      RETURNS trigger \
      AS \
      $set_address_info$ \
      begin \
        NEW.street_no_int = COALESCE(NEW.street_no, '0')::int; \
        NEW.is_odd = mod(NEW.street_no_int,2) = 1; \
      RETURN NEW; \
      END; \
      $set_address_info$ \
      LANGUAGE plpgsql;}

      execute %{
        CREATE TRIGGER add_addr_info \
            BEFORE INSERT ON addresses \
            FOR EACH ROW \
            EXECUTE PROCEDURE set_address_info();}
  end
  
  def self.down
    execute %{DROP TRIGGER add_addr_info ON addresses;}
    execute %{DROP FUNCTION set_address_info();}
  end
end
