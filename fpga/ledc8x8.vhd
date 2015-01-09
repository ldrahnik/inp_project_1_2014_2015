-- Autor: Lukas Drahnik, xdrahn00
-- Datum: 4.11.2014, 23:55

library ieee ;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all ;

entity ledc8x8 is
	port (
		SMCLK: in std_logic;
		RESET: in std_logic;
		ROW: out std_logic_vector (0 to 7);
		LED: out std_logic_vector (7 downto 0)
	);
end ledc8x8;

architecture architect of ledc8x8 is
	signal clock: std_logic;
	signal decoder: std_logic_vector (7 downto 0);
	signal selectedRow: std_logic_vector (7 downto 0) := "10000000";	-- nastavime prvni radek
	signal counter: std_logic_vector(7 downto 0);

begin
	process (SMCLK, RESET)
	begin
		if RESET = '1' then												-- pri resetu vynulujeme counter
			counter <= "00000000";
		elsif SMCLK'event and SMCLK = '1' then							-- inkrementujeme counter a kontrolujeme nastaveni hodin
			counter <=  counter + 1;
			if counter(7 downto 0) = "11111111" then
				clock <= '1';
			else
				clock <= '0';
			end if;
			if clock = '1' then 										-- kontrolujeme nastaveni hodin, pripadne posuneme na dalsi radek
				selectedRow <= selectedRow(0) & selectedRow(7 downto 1);
			end if;
		end if;
	end process;

	with selectedRow select
																		-- nastavime prislusnou kombinaci rozsvicenych ledek ["LED" when "ROW"], bit je v aktivni v 0
		decoder <= 	"11111110" when "10000000",
					"11111110" when "01000000",
					"11111110" when "00100000",
					"10001110" when "00010000",
					"01101000" when "00001000",
					"01101111" when "00000100",
					"01101111" when "00000010",
					"10001111" when "00000001",
					"11111111" when others;

																		-- priradime konkretni hodnoty pro "ROW" a "LED"
	ROW <= selectedRow;
	LED <= decoder;
	
end architecture;
