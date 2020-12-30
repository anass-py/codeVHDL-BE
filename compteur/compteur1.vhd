library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity compteur1 is
port ( clk0 : in STD_LOGIC;
	  A : out STD_LOGIC_VECTOR(3 downto 0)
	   	   );
end compteur1;
	  
	 architecture comp OF compteur1 is
		signal  comp : std_logic_vector(3 downto 0); 
	 begin 
	 process(clk0)
	 begin 
	 
	 if (rising_edge(clk0))then
	 
		
		comp <= comp + 1;
		end if;
		
		end process;
		A <= comp;
		end comp;
		
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 