library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity etat is
port (
continue : in std_logic;
start_stop : in std_logic;
etat : out std_logic_vector(1 downto 0));
end etat ;
 architecture arch of etat is 
 begin 
process(continue,start_stop) 
begin 
if (continue ='0' and start_stop ='0') then
etat <= "00";
elsif (continue ='0' and start_stop ='1') then
etat <= "01";
elsif(continue ='1' and start_stop ='0') then
etat <= "10";
elsif(continue ='1' and start_stop ='1') then
etat <= "11";

end if ; 
 
end process;
end arch;
