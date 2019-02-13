library IEEE;
use IEEE.NUMERIC_BIT.ALL;

entity LCD5_Module is
	port(Clk, rst: in bit; RS, RW, EN: out bit; DATA: out bit_vector(7 downto 0));
end LCD5_Module;

architecture Behavioral of LCD5_Module is

signal cuenta : integer range 0 to 10; -- Cuenta para ponerlas en el LCD para los nombres
 
begin


process(Clk) --Proceso de las instrucciones
	begin
		if Clk='1' and Clk'event and cuenta <=10	then
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
				when 4 => --Escribir la L
					RS<='1';
					DATA <="01001100";
					Cuenta<= Cuenta+1;
				when 5 => --Escribir la l
					DATA <="01001100";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 6 => --Escribir la E
					DATA <="01000101";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 7 => --Escribir N
					DATA <="01001110";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 8 => --Escribe la O
					DATA <="01001111";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 9 => --Escribir !
					DATA <="00100001";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 10 => 
					RS<='0';
					DATA <="00000000";
				when others => NULL;
			end case;
			end if;
			end if;
	end process;
EN <=Clk; -- el enable es igual al clock

end Behavioral;
