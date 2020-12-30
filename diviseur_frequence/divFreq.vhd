library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity DivFreq is
	port(
	
		clk_50M		: in std_logic;
		reset 		: in std_logic;
		
		clk_1		: out std_logic
		);
end DivFreq ;


architecture arch of DivFreq is
	signal compteur : integer;
	signal clk_1prime : std_logic;
begin
	process (clk_50M, reset, clk_1prime)
	begin 
		if reset = '1'
		then 
		compteur <= 1;
		clk_1prime <= '0';
		elsif rising_edge (clk_50M)
		then 
		if compteur < 25000000 then compteur <= compteur +1;
		--if compteur < 25 then compteur <= compteur +1;
		else compteur <= 1; end if;
		if compteur = 1 then clk_1prime <= not(clk_1prime); end if;
		end if;
		
	end process;
	clk_1 <= clk_1prime;
end arch;