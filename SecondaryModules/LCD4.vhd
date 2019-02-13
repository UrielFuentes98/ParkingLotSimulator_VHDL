library IEEE;
use IEEE.NUMERIC_BIT.ALL;

entity LCD4_Module is
	port(Clk, rst: in bit;Codigo: in integer range 0 to 3; RS, RW, EN: out bit; DATA: out bit_vector(7 downto 0));
end LCD4_Module;

architecture Behavioral of LCD4_Module is

signal cuenta : integer range 0 to 12; -- Cuenta para ponerlas en el LCD para los nombres
 
begin


process(Clk) --Proceso de las instrucciones
	begin
		if Clk='1' and Clk'event and cuenta <=12 then
		if rst='1' then cuenta <= 0;
		else 
			case cuenta is --para la máquina de estados, el case va avanzando.
				when 0 =>
					RS<= '0';
					DATA <= "00001000";
					Cuenta<=cuenta+1;
				when 1 => --Clear del display
					DATA<="00000001";
					RS<='0';
					Cuenta<=cuenta+1;
				when 2 => --Activar las 2 lineas
					DATA<= "00111000";
					RS<='0';
					Cuenta<=Cuenta+1;
				when 3 => --Hacer el blink
					DATA<="00001111";
					RS<='0';
					Cuenta<=Cuenta+1;
				when 4 => --Escribir C
					RS<='1';
					DATA <="01000011";
					Cuenta<= Cuenta+1;
				when 5 => --Escribir O
					DATA <="01001111";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 6 => --Escribir la D
					DATA <="01000100";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 7 => --Escribir I
					DATA <="01001001";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 8 => --Escribe la G
					DATA <="01000111";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 9 => --Escribir O
					DATA <="01001111";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 10 => --Escribir =
					DATA <="00111101";
					RS<='1';
					Cuenta <= Cuenta+1;
				when 11 => 
					case Codigo is
					when 0=>
					DATA <="00110000";
					when 1 =>
					DATA <="00110001";
					when 2 =>
					DATA <="00110010";
					when 3 =>
					DATA <="00110011";
					END CASE; 
					RS <= '1';
					Cuenta <= Cuenta +1;
				when 12 => 
					RS<='0';
					DATA <="00000000";
				when others => NULL;
			end case;
		end if;
		end if;
	end process;
	
EN <=Clk; -- el enable es igual al clock

end Behavioral;

