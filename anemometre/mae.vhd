library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity mae is
port(raz_n: in std_logic ;
clk_1 : in std_logic;
data : in std_logic_vector(7 downto 0);
etat : in std_logic_vector(1 downto 0);
data_anemometre : out std_logic_vector(7 downto 0);
data_valid :out std_logic);
end mae;

architecture arch of mae is

begin 
  process (etat)
  begin 
  if raz_n ='1' then
  data_anemometre<="00000000";
  data_valid<='0';
 else
case etat is
  when "00" => data_anemometre <= ("00000000") ;  data_valid <='0' ;
  when "01" => data_anemometre <= data; 
 data_valid <='1';
  when "10" => data_anemometre <= data; data_valid <= '1';
  when "11"=>  data_anemometre <= data;  data_valid <= '1';
  end case ;
 end if;
  end process;
end arch;