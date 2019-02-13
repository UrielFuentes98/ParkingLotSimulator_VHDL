
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DebounceUsar is
 Port(CLK, SIGNALIN: IN BIT; SIGNALOUT: OUT BIT); 
end DebounceUsar;

architecture Behavioral of DebounceUsar is
signal Q, Q1 : bit;
	
begin
	process(CLK)-- el clock mete la señal del botón en el flip flop. 
		begin 
		if CLK = '1' and CLK'event then
			Q <= SIGNALIN ; Q1 <= Q;
			SIGNALOUT <= Q1;
		end if;
	end process;


end Behavioral;

