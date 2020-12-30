library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity final is
port
(
raz_n,clk_50M : in std_logic;
in_freq : in std_logic;
continue : in std_logic ;
start_stop : in std_logic ;
data_anemometre : out std_logic_vector(7 downto 0);
data_valid : out std_logic);
end final ;
architecture arch of final is
signal clk1_prime : std_logic ;
signal data_prime: std_logic_vector(7 downto 0) ;
signal etat_prime : std_logic_vector(1 downto 0 );

component divis_freq 
port (

clk_50M : in std_logic ;
clk1 : out std_logic );
end component ;
component test 
port(
raz_n : in std_logic ;
in_freq : in std_logic ;
clk_1 : in std_logic ;
--reset : in std_logic ; 
data : out std_logic_vector(7 downto 0 ));
end component ;
component etat
port(
continue : in std_logic;
start_stop : in std_logic;
etat : out std_logic_vector(1 downto 0));
end component ;
component mae 
port(
raz_n : in std_logic ;
data : in std_logic_vector(7 downto 0);
etat : in std_logic_vector(1 downto 0);
data_anemometre : out std_logic_vector(7 downto 0);
data_valid : out std_logic);
end component ;
begin 
DivFrequ : divis_freq
port map (clk_50M , clk1 => clk1_prime) ;
testu:test 
port map ( raz_n, in_freq , clk_1=>clk1_prime  , data => data_prime);
etatu: etat 
port map ( continue => continue , start_stop => start_stop , etat =>etat_prime);
maee: mae 
port map (raz_n ,data=>data_prime , etat=>etat_prime , data_anemometre=>data_anemometre , data_valid => data_valid);
end arch;