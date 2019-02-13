library IEEE;
use IEEE.numeric_bit.all;
--posicion: determina la posicion que debe tomar el servo.
--ClkPWM: reloj interno del Spartan. Señal PWM: señal para controlar
--al servo. 
entity pwmGen is
	port (Posicion, ClkPWM : in bit; SeñalPWM : out bit);
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

--se determina el duty cycle de la señal PWM
process(ClkPWM)
begin
if ClkPWM = '1' and ClkPWM'event then 
	case Posicion is 
	
	when '0' => 
	if rango < 40_000 then SeñalPWM <= '1';
	else SeñalPWM <= '0'; --para poner al servo en °0
	end if;
	
	when '1' => 
	if rango < 80_000 then SeñalPWM <= '1';
	else SeñalPWM <= '0'; --para poner al servo en °90
	end if;
end case;
end if;
end process;



end Behavioral;