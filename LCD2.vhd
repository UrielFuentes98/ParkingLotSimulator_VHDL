library IEEE;
use IEEE.NUMERIC_BIT.ALL;

entity LCD2_Module is
	port(Clk, rst: in bit; Digito: in bit_vector(2 downto 0); RS, RW, EN: out bit; DATA: out bit_vector(7 downto 0));
end LCD2_Module;

architecture Behavioral of LCD2_Module is

signal cuenta : integer range 0 to 14; -- Cuenta para ponerlas en el LCD para los nombres
 
begin


process(Clk) --Proceso de las instrucciones
	begin
		if Clk='1' and Clk'event and cuenta <=14	then
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
				when 4 => --Escribir la I
					RS<='1';
					DATA <="01001001";
					Cuenta<= Cuenta+1;
				when 5 => --Escribir la N
					DATA <="01001110";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 6 => --Escribir la G
					DATA <="01000111";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 7 => --Escribir R
					DATA <="01010010";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 8 => --Escribe la E
					DATA <="01000101";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 9 => --Escribir S
					DATA <="01010011";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 10 => --Escribir A
					DATA <="01000001";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 11 => --Escribir R
					DATA <="01010010";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 12 => --Escribir =
					DATA <="00111101";
					RS<='1';
					Cuenta<= Cuenta + 1;
				when 13 => 
					case Digito is --Dependiendo de que numero se vaya a ingresar se escribe ese numero. 
					when "000" =>
					DATA <="00110000";
					when "001" =>
					DATA <="00110001";
					when "010" =>
					DATA <="00110010";
					when "011" =>
					DATA <="00110011";
					when "100" =>
					DATA <="00110100";
					when "101" =>
					DATA <="00110101";
					when "110" =>
					DATA <="00110110";
					when "111" =>
					DATA <="00110111";
					end case;
					RS<='1';
					Cuenta <= Cuenta + 1;
				when 14 => 
					RS<='0';
					DATA <="00000000";
				when others => NULL;
			end case;
			end if;
			end if;
	end process;
EN <=Clk; -- el enable es igual al clock

end Behavioral;

