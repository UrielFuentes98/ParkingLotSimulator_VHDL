library IEEE;
use IEEE.NUMERIC_BIT.ALL;

entity LCD3_Module is
	port(Clk, rst: in bit; DecHrs, UniHrs, DecMin, UniMin: in bit_vector(3 downto 0); RS, RW, EN: out bit; DATA: out bit_vector(7 downto 0));
end LCD3_Module;

architecture Behavioral of LCD3_Module is

signal cuenta : integer range 0 to 27; -- Cuenta para ponerlas en el LCD para los nombres
signal horas : integer range 1 to 25; -- Cuenta para el case de las horas
begin

--El valor de las horas depende de la señal de sus unidades y de sus decenas.
horas <= (to_integer(unsigned(DecHrs)) * 10) + (to_integer(unsigned(UniHrs))) + 1 ;

process(Clk) --Proceso de las instrucciones
	begin
		if Clk='1' and Clk'event and cuenta <=27 then
		if rst='1' then cuenta <= 0;
		else 
			case cuenta is --para la máquina de estados, el case va avanzando.
				when 0 =>
					RS <= '0';
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
				when 4 => --Escribir la T
					RS <='1';
					DATA <="01010100";
					Cuenta<= Cuenta+1;
				when 5 => --Escribir la I
					DATA <="01001001";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 6 => --Escribir la E
					DATA <="01000101";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 7 => --Escribir la M
					DATA <="01001101";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 8 => --Escribir la P
					DATA <="01010000";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 9 => --Escribir la O
					DATA <="01001111";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 10 => --Escribir la =
					DATA <="00111101";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 11 =>
				case DecHrs is -- Va a escribir el digito de las decenas de las horas.
					when "0000" =>
					DATA <="00110000";
					when "0001" =>
					DATA <="00110001";
					when "0010" =>
					DATA <="00110010";
					when others =>
					DATA <="00110000";
				end Case;
					RS<='1';
					Cuenta<= Cuenta+1;
				when 12 =>
				case UniHrs is -- Va a imprimir el digito de las unidades de las horas.
					when "0000" =>
					DATA <="00110000";
					when "0001" =>
					DATA <="00110001";
					when "0010" =>
					DATA <="00110010";
					when "0011" =>
					DATA <="00110011";
					when "0100" =>
					DATA <="00110100";
					when "0101" =>
					DATA <="00110101";
					when "0110" =>
					DATA <="00110110";
					when "0111" =>
					DATA <="00110111";
					when "1000" =>
					DATA <="00111000";
					when "1001" =>
					DATA <="00111001";
					when others => 
					DATA <="00110000";
					end case;
					RS<='1';
					Cuenta<= Cuenta+1;
				when 13 => -- Escribir :
				DATA <="00111010";
				RS<='1'; 
				Cuenta<=Cuenta+1;
				when 14 => 
				case DecMin is -- Escribe las decenas de los minutos
					when "0000" =>
					DATA <="00110000";
					when "0001" =>
					DATA <="00110001";
					when "0010" =>
					DATA <="00110010";
					when "0011" =>
					DATA <="00110011";
					when "0100" =>
					DATA <="00110100";
					when "0101" =>
					DATA <="00110101";
					when "0110" =>
					DATA <="00110110";
					when others => 
					DATA <="00110000";
					END CASE;
					RS<='1';
					Cuenta<= Cuenta+1;
				when 15 => 
				case UniMin is -- Escribe las unidades de los minutos.
					when "0000" =>
					DATA <="00110000";
					when "0001" =>
					DATA <="00110001";
					when "0010" =>
					DATA <="00110010";
					when "0011" =>
					DATA <="00110011";
					when "0100" =>
					DATA <="00110100";
					when "0101" =>
					DATA <="00110101";
					when "0110" =>
					DATA <="00110110";
					when "0111" =>
					DATA <="00110111";
					when "1000" =>
					DATA <="00111000";
					when "1001" =>
					DATA <="00111001";
					when others => 
					DATA <="00110000";
					end case;
					RS<='1';
					Cuenta<= Cuenta+1;
				when 16 => -- Realiza el salto de linea para poner el otro nombre
					RS <= '0'; --Como es secuencial, se le tiene que dar RS primero.
					DATA <= "11000000";
					Cuenta <= Cuenta+1;
				when 17 => --Escribir la D
					RS <='1';
					DATA <="01000100";
					Cuenta<= Cuenta+1;
				when 18 => --Escribir la E
					DATA <="01000101";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 19 => --Escribir la B
					DATA <="01000010";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 20 => --Escribir E
					DATA <="01000101";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 21 => --Escribe S
					DATA <="01010011";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 22 => -- Escribe =
					DATA <="00111101";
					RS<='1';
					Cuenta<= Cuenta+1;
				when 23 => --Escribir $
					RS <='1'; 
					DATA <= "00100100";
					Cuenta <= cuenta+1;
				when 24 =>
				case horas is --Escribe el primer digito de la cantidad de dinero que se debe.
				when 1 =>
					DATA <= "00110000";
				when 2 =>
					DATA <= "00110000";
				when 3 =>
					DATA <= "00110000";
				when 4 =>
					DATA <= "00110000";
				when 5 =>
					DATA <= "00110000";
				when 6 =>
					DATA <= "00110000";
				when 7 =>
					DATA <= "00110001";
				when 8 =>
					DATA <= "00110001";
				when 9 =>
					DATA <= "00110001";
				when 10 =>
					DATA <= "00110001";
				when 11 =>
					DATA <= "00110001";
				when 12 =>
					DATA <= "00110001";
				when 13 =>
					DATA <= "00110001";
				when 14 =>
					DATA <= "00110010";
				when 15 =>
					DATA <= "00110010";
				when 16 =>
					DATA <= "00110010";
				when 17 =>
					DATA <= "00110010";
				when 18 =>
					DATA <= "00110010";
				when 19 =>
					DATA <= "00110010";
				when 20 =>
					DATA <= "00110011";
				when 21 =>
					DATA <= "00110011";
				when 22 =>
					DATA <= "00110011";
				when 23 =>
					DATA <= "00110011";
				when 24 =>
					DATA <= "00110011";
				when 25 =>
					DATA <= "00110011";
				end case;
				RS<='1';
				Cuenta <= Cuenta+1;
				when 25 =>
				case horas is -- Escribe el segundo digito de la cantidad de dinero que se debe.
				when 1 =>
					DATA <= "00110001";
				when 2 =>
					DATA <= "00110011";
				when 3 =>
					DATA <= "00110100";
				when 4 =>
					DATA <= "00110110";
				when 5 =>
					DATA <= "00110111";
				when 6 =>
					DATA <= "00111001";
				when 7 =>
					DATA <= "00110000";
				when 8 =>
					DATA <= "00110010";
				when 9 =>
					DATA <= "00110011";
				when 10 =>
					DATA <= "00110101";
				when 11 =>
					DATA <= "00110110";
				when 12 =>
					DATA <= "00111000";
				when 13 =>
					DATA <= "00111001";
				when 14 =>
					DATA <= "00110001";
				when 15 =>
					DATA <= "00110010";
				when 16 =>
					DATA <= "00110100";
				when 17 =>
					DATA <= "00110101";
				when 18 =>
					DATA <= "00110111";
				when 19 =>
					DATA <= "00111000";
				when 20 =>
					DATA <= "00110000";
				when 21 =>
					DATA <= "00110001";
				when 22 =>
					DATA <= "00110011";
				when 23 =>
					DATA <= "00110100";
				when 24 =>
					DATA <= "00110110";
				when 25 =>
					DATA <= "00110111";
				end case;
				RS<='1';
				Cuenta <= Cuenta+1;
				when 26 => 
				case horas is --Escribe el tercer digito de la cantidad de dinero que se debe.
				when 1 =>
				DATA <= "00110101";
				when 2 =>
				DATA <= "00110000";
				when 3 =>
				DATA <= "00110101";
				when 4 =>
				DATA <= "00110000";
				when 5 =>
				DATA <= "00110101";
				when 6 =>
				DATA <= "00110000";
				when 7 =>
				DATA <= "00110101";
				when 8 =>
				DATA <= "00110000";
				when 9 =>
				DATA <= "00110101";
				when 10 =>
				DATA <= "00110000";
				when 11 =>
				DATA <= "00110101";
				when 12 =>
				DATA <= "00110000";
				when 13 =>
				DATA <= "00110101";
				when 14 =>
				DATA <= "00110000";
				when 15 =>
				DATA <= "00110101";
				when 16 =>
				DATA <= "00110000";
				when 17 =>
				DATA <= "00110101";
				when 18 =>
				DATA <= "00110000";
				when 19 =>
				DATA <= "00110101";
				when 20 =>
				DATA <= "00110000";
				when 21 =>
				DATA <= "00110101";
				when 22 =>
				DATA <= "00110000";
				when 23 =>
				DATA <= "00110101";
				when 24 =>
				DATA <= "00110000";
				when 25 =>
				DATA <= "00110101";
				end case;
				RS<='1';
				Cuenta <= Cuenta+1;
				when 27 => 
					RS<='0';
					DATA <="00000000";
				when others => NULL;
			end case;
		end if;
		end if;
	end process;
	
EN <=Clk; -- el enable es igual al clock

end Behavioral;

