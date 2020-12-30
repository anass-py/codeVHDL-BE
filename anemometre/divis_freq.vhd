library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
ENTITY divis_freq is
port ( --reset:in std_logic;
		clk_50M: in STD_LOGIC;
		clk1  : OUT STD_LOGIC);
END divis_freq ;
ARCHITECTURE devi OF divis_freq IS
signal   cpt : std_logic_vector (25 downto 0);
signal Qp: std_logic;
BEGIN
	PROCESS
	BEGIN

	
	wait until rising_edge(clk_50M) ;
	 if cpt<50000000  then
	 cpt <= cpt +1;
	 else 
	 cpt<= (others =>'0');
	 end if;
	 if cpt<25000000  then
	 Qp<='0';
	 else 
	  Qp<='1';
	  end if;

	


	

	

	
	END PROCESS;
	clk1<=Qp;
	--Q <= cpt(23) or cpt(21) or cpt(20) or   cpt(18) or   cpt(17) or   cpt(16) or cpt(12) or cpt(11) or  cpt(9)or  cpt(8)  ;
	end devi;