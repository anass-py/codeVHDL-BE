library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity anemometre is
port
(
clk,chipselect, write_n, reset_n : in std_logic;
in_freq : in std_logic;
--write_n : in std_logic ;
writedata : in std_logic_vector (31 downto 0);
address : in std_logic;
readdata : out std_logic_vector (31 downto 0));
end anemometre ;
architecture arch of anemometre is
signal clk1_prime : std_logic ;
signal data_prime: std_logic_vector(7 downto 0) ;
signal etat_prime : std_logic_vector(1 downto 0 );
signal start_stop : std_logic ; 
signal data_valid : std_logic ; 
signal data_anemometre : std_logic_vector(7 downto 0) ;
signal raz_n : std_logic ;
signal continue : std_logic ;
signal config : std_logic_vector (2 downto 0);



component divis_freq 
port (

clk : in std_logic ;
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
port map (clk , clk1 => clk1_prime) ;
testu:test 
port map ( raz_n, in_freq , clk_1=>clk1_prime  , data => data_prime);
etatu: etat 
port map ( continue => continue , start_stop => start_stop , etat =>etat_prime);
maee: mae 
port map (raz_n ,data=>data_prime , etat=>etat_prime , data_anemometre=>data_anemometre , data_valid => data_valid);


raz_n <= config(0);
continue <= config(1);
start_stop <= config(2);

registers: process (clk, reset_n)
begin
  if reset_n = '0' then
  config <= (others => '0');
  elsif clk'event and clk = '1' then
    if chipselect ='1' and write_n = '0' then
      if address = '0' then
      config <= (writedata (2 downto 0));
      end if;
    end if;
  end if;
end process registers;
readdata <= X"0000000"&'0'&config when address = '0' else X"00000"&"000"&data_valid&data_anemometre;

end arch;