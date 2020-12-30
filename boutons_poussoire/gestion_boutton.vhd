LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY gestion_boutton IS
	PORT (
			clk, chipselect, write_n, reset_n: in std_logic;
			writedata : in std_logic_vector (31 downto 0);
			address : in std_logic;
			readdata : out std_logic_vector (31 downto 0);
			BP_Babord,BP_Tribord, BP_STBY  : in std_logic;  
			ledBabord, ledTribord,ledSTBY, out_bip : out std_logic		  
		  );
END gestion_boutton  ;

ARCHITECTURE arch_gestion_boutton OF gestion_boutton IS
signal fin_tempo, val_tempo, val_bip, fin_bip, bip_simple, bip_double: std_logic;
signal codeFonction: std_logic_vector (3 downto 0);
signal clk_1Hz, bip, clk_50, clk_100, raz_n : std_logic;
signal compt_bip: integer range 0 to 200;
signal count_1: integer:=1;
signal count_50: integer:=1;
signal count_100: integer:=1;
signal tmp_1 : std_logic := '0';
signal tmp_50 : std_logic := '0';
signal tmp_100 : std_logic := '0';
signal s : integer range 0 to 7;
signal led_faible,led_intense : std_logic;
signal d : std_logic_vector (7 downto 0);
TYPE State_button IS (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13);
TYPE States_bip IS (s0,s1,s2);
begin

--********************************************************************
--state machine bouton poussoir
--********************************************************************
gestion_bp:process (raz_n, clk_100)
variable State : State_button;
begin
	if raz_n ='0' then
	state:= s0;
	codeFonction <="0000";
	elsif rising_edge(clk_100) then
	case state is
	when s0 =>
		if BP_Babord='0' then 
		state:=s1; codeFonction <="0001";
		end if;
		if BP_Tribord='0' then 
		state:=s2; codeFonction <="0010";
		end if;
		if BP_STBY='0' then 
		state:=s3; codeFonction <="0000"; 
		end if;
		ledSTBY <= clk_1Hz; ledBabord <= led_faible; ledTribord <= led_faible;
	when s1 =>
		if BP_Babord='1' then 
		state:=s0; codeFonction <="0000";
		end if;
		ledSTBY <= clk_1Hz; ledBabord <= led_faible; ledTribord <= '0';
	when s2 =>
		if BP_Tribord='1' then 
		state:=s0; codeFonction <="0000";
		end if;
		ledSTBY <= clk_1Hz; ledBabord <= '0'; ledTribord <= led_faible;
	when s3 =>
		if BP_STBY='1' then 
		state:=s4; codeFonction <="0011";
		end if;
		ledSTBY <= clk_1Hz; ledBabord <= led_intense; ledTribord <= led_intense;
	when s4 =>
		if BP_STBY='0' then 
		state:=s5; codeFonction <="0000";
		end if;
		if BP_Babord='0' and BP_Tribord='1'then 
		state:=s6; codeFonction <="0011"; val_tempo <='1';
		end if;
		if BP_Tribord='0' and BP_Babord='1'then 
		state:=s9; codeFonction <="0011";val_tempo <='1';
		end if;
		ledSTBY <= '1'; ledBabord <= clk_50; ledTribord <= clk_50;
	when s5 =>
		if BP_STBY='1' then 
		state:=s0; codeFonction <="0000";
		end if;
		ledBabord <= clk_50; ledTribord <= clk_50;
	when s6 =>
		if BP_Babord='0' and fin_tempo='1' then 
		state:=s7; codeFonction <="0101";val_tempo <='0'; bip_double<='1';
		end if;
		if BP_Babord='1' and fin_tempo='0' then 
		state:=s8; codeFonction <="0100"; val_tempo <='0'; bip_simple<='1';
		end if;
		ledBabord <= '0'; ledTribord <= clk_50;
	when s7 =>
		if fin_bip='1' then 
		state:=s13; codeFonction <="0101"; bip_double<='0';
		end if;
		ledBabord <= bip ; ledTribord <= clk_50;
	when s8 =>
		if fin_bip='1' then 
		state:=s4; codeFonction <="0011";bip_simple<='0'; 
		end if;
		ledBabord <= bip ; ledTribord <= clk_50;
	when s9 =>
		if BP_Tribord='0' and fin_tempo='1' then 
		state:=s10; codeFonction <="0110"; val_tempo <='0'; bip_double<='1';
		end if;
		if BP_Tribord='1' and fin_tempo='0' then 
		state:=s11; codeFonction <="0111"; val_tempo <='0'; bip_simple<='1';
		end if;
		ledBabord <= clk_50; ledTribord <= '0';
	when s10 =>
		if fin_bip='1' then 
		state:=s12; codeFonction <="0110"; bip_double<='0';
		end if;
		ledBabord <= clk_50; ledTribord <= bip;
	when s11 =>
		if fin_bip='1' then 
		state:=s4; codeFonction <="0011"; bip_simple<='0';
		end if;
		ledBabord <= clk_50; ledTribord <= bip;
	when s12 =>
		if BP_Tribord='1'  then 
		state:=s4; codeFonction <="0011"; bip_double<='0';
		end if;
		ledBabord <= clk_50; ledTribord <= clk_50;
	when s13 =>
		if BP_Babord='1'  then 
		state:=s4; codeFonction <="0011"; bip_double<='0';
		end if;
		ledBabord <= clk_50; ledTribord <= clk_50;
	end case;
	end if;
	end process gestion_bp;

-------------------------PROCESS DE TEMPORISATIONS ----------------------------------------------
gen_tempo:process (raz_n, clk_100)
variable duree_tempo : integer range 0 to 300;
begin
	if raz_n ='0' then
	duree_tempo:= 0; fin_tempo <='0';
	elsif rising_edge(clk_100) then
		if val_tempo ='1' then
		duree_tempo:=duree_tempo+1;
			if duree_tempo=300 then duree_tempo:=0;
			fin_tempo <='1';
			end if;
		else duree_tempo:=0;	fin_tempo <='0';
		end if;
	end if;
end process gen_tempo;
---------------------- PROCESS DE DIVISEURS DE FREQUENCES -------------------------------
gene_100:	process(clk,raz_n)
	BEGIN
		if raz_n= '0' then
        count_100<=1;
        tmp_100<='0';
		elsif rising_edge(clk) then
			count_100<= count_100 +1;
			if (count_100 =  249999 )then
				tmp_100 <= NOT tmp_100;
                count_100 <= 1;
			end if;
		end if;
		clk_100 <= tmp_100;	
	end process gene_100;
--*******************************************************************	
--génération  1Hz
--*******************************************************************
gene_1hz : process(Clk_100,raz_n)
    begin
        if(raz_n='0') then
        count_1<=1;
        tmp_1<='0';
    elsif rising_edge(clk_100) then
        count_1 <=count_1+1;
        if (count_1 = 49) then
            tmp_1 <= NOT tmp_1;
            count_1 <= 1;
        end if;
    end if;
    clk_1hz <= tmp_1;
end process gene_1hz;
--*******************************************************************	
--génération  50 Hz
--*******************************************************************
gene_50 : process(Clk_100,raz_n)
    begin
        if(raz_n='0') then
        count_50<=1;
        tmp_50<='0';
    elsif rising_edge(clk_100) then
        count_50 <=count_50+1;
        if (count_50 = 2) then
            tmp_50 <= NOT tmp_50;
            count_50 <= 1;
        end if;
    end if;
    clk_50 <= tmp_50;
end process gene_50;

--------------------------GENERATIONS DES BIPS (simple et double )-------------------------------------------
double_bip:process (raz_n, bip_simple,bip_double, clk_100)
variable state_bip : States_bip;
begin
	if raz_n ='0' or (bip_simple='0' and bip_double='0') then
	state_bip:= s0;
	compt_bip <= 0; 
	fin_bip <='0';
	bip<='0';
	elsif rising_edge(clk_100) then
	case state_bip is
	when s0 =>
		if bip_simple='1' or bip_double='1' then 
		state_bip:=s1;
		end if;
	when s1 =>
		compt_bip<=compt_bip+1;
		if bip_simple='1' then
			if compt_bip >=30 then compt_bip<=0; fin_bip <='1';
			state_bip:=s2; bip <='0';
			end if;
		end if;
		if bip_double='1' then
			if compt_bip >=90 then compt_bip<=0; fin_bip <='1';
			state_bip:=s2; bip <='0';
			end if;
		end if;
		if (compt_bip >= 1 and compt_bip <= 30) or (compt_bip >= 60 and compt_bip <= 90) then
		bip <='1';
		else bip<='0';
		end if;
	when s2 =>
		if bip_simple='0' and bip_double='0' then 
		state_bip:=s0;
		end if;
	end case;
	end if;
end process double_bip;


intensite_LED: process(clk_100,raz_n,s)
begin
    if raz_n='0' then
        s<=0;
    elsif clk_100'event and clk_100 ='1' then
        s <= s + 1;
        if (s=6) then
            s <= 0;
        end if;
        case s is
             when 0 => d <="10000000";
        	 when 1 => d <="11000000";
        	 when 2 => d <="11100000";
        	 when 3 => d <="11110000";
        	 when 4 => d <="11111000";
        	 when 5 => d <="11111100";
        	 when 6 => d <="11111110";
        	 when others => d <="00000000";
    	end case;
    end if;
	led_faible <= d(1);
	led_intense <= d(7);
end process intensite_LED;

ecriture: process (clk, reset_n)
	begin
	if reset_n = '0' then
	raz_n <=  '0';
	elsif rising_edge(clk) then
		if chipselect ='1' and write_n = '0' then
			if address ='0' then
			raz_n <=  writedata(0);
			end if;
		end if;
	end if;
end process ecriture;

lecture: process (address)
	begin
		case address is
			when '0' =>
			readdata(0) <= raz_n;
			when '1' =>
			readdata(3 downto 0) <= codeFonction  ;
			end case;
end process lecture;

out_bip <= bip;		
end arch_gestion_boutton;		

