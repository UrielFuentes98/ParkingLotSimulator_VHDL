library IEEE;
use IEEE.numeric_bit.all;
--posicion: determina la posicion que debe tomar el servo.
--ClkPWM: reloj interno del Spartan. Se�al PWM: se�al para controlar
--al servo. 
entity pwmGen is
	port (Posicion, ClkPWM : in bit; Se�alPWM : out bit);
end pwmGen;

architecture Behavioral of pwmGen is
signal rango : integer range 0 to 999_999;
begin

process (ClkPWM) --Lo que genera la frecuencia del pulso PWM
begin
if ClkPWM = '1' and ClkPWM'event then 
if rango = 999_999 then 
rango <= 0;
else
rango <= rango + 1;
end if;
end if;
end process; 

--se determina el duty cycle de la se�al PWM
process(ClkPWM)
begin
if ClkPWM = '1' and ClkPWM'event then 
	case Posicion is 
	
	when '0' => 
	if rango < 40_000 then Se�alPWM <= '1';
	else Se�alPWM <= '0'; --para poner al servo en �0
	end if;
	
	when '1' => 
	if rango < 80_000 then Se�alPWM <= '1';
	else Se�alPWM <= '0'; --para poner al servo en �90
	end if;
end case;
end if;
end process;



end Behavioral;