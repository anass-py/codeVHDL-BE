library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Compteur is port (
	clk: in std_logic;
	reset: in std_logic;
	FREQ : in std_logic_vector (7 downto 0);
	sortie1 : out std_logic_vector( 7 downto 0));
end Compteur;


architecture description of Compteur is
 signal cmt:std_logic_vector(7 downto 0);
 begin
 
process (clk,reset) begin
  if (reset ='0') then cmt <="00000000";
  elsif (clk'event and clk='1') then 
	if (cmt<=FREQ) then
  		cmt <= cmt + '1';
	else 
		cmt<= "00000000";
	end if;
  end if;
  

 end process;
 
 sortie1 <= cmt;
 end description;