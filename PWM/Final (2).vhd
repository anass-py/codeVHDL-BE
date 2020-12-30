library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity final is
	port(
		-- entree
		clk 		: in std_logic;
		reset		: in std_logic;
		freq 		: in std_logic_vector(7 downto 0);
		duty 		: in std_logic_vector(7 downto 0);
		-- sortie
		pwm_out		: out std_logic
	);
end entity;
	
architecture arch of final is
	signal cmp_out: std_logic_vector(7 downto 0);
	
component compteur
	port (
	clk: in std_logic;
	reset: in std_logic;
	FREQ : in std_logic_vector (7 downto 0);
	sortie1 : out std_logic_vector( 7 downto 0));
end component;

component comparateur 
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
end component ;
	
begin
	
	compteur0 : compteur 
	port map(clk=>clk,freq=>freq, reset=>reset, sortie1 => cmp_out);
	
	comparateur0 : comparateur
	port map(clk=>clk,freq=>freq, reset=>reset, E => cmp_out , duty=>duty , pwm_out=>pwm_out);

end arch;