-------------------------------- LIBRARIES -----------------------------
library ieee;
use ieee.std_logic_1164.all;
-- Pour utiliser les UNSIGNED et les faire des operations arithmetiques
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-------------------------------- ENTITY ---------------------------
entity comparateur is
	port(
		-- entree
		E			: in std_logic_vector(7 downto 0);
		clk 		: in std_logic;
		reset		: in std_logic;
		freq 		: in std_logic_vector(7 downto 0);
		duty 		: in std_logic_vector(7 downto 0);
		-- sortie
		pwm_out		: out std_logic
		);
end comparateur ;

--------------------------------- ARCHITRECTURE ------------------------
architecture arch of comparateur is

begin
	process (clk, reset)
	begin 
		if reset = '0'
		then pwm_out <= '0';
		
		--Comparaison 
		elsif (clk'event and clk='1') then
			if(freq > duty) then 
				if(E < duty) then pwm_out <= '1';
				else pwm_out <= '0';
				end if;
			end if;
		end if;
		
	end process;
	
end arch;