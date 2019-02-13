--modulo contador modulo 60 para utilizarse para la cuenta de minutos y segundos

library IEEE;
use IEEE.numeric_bit.all;

entity MOD60 is
	--clk: reloj del contador, ciclo: indica el reset del modulo, Dec: bit_vector con el valor
	--de las decenas, Uni: bit_vector con el valor de las unidades. 
	port(reset,enable, clk : in bit; ciclo: out bit; Dec, Uni : out bit_vector(3 downto 0));
end MOD60;

architecture Behavioral of MOD60 is
	--Dec1: unsigned interno para guardar el valor de las decenas
	--Uni1: unsigned interno para guardar el valor de las unidades.
	signal Dec1, Uni1 : unsigned(3 downto 0);
begin

	--process para llevar a cabo la cuenta.
	process(clk)
		begin 
		--el contador trabaja en transicion positiva
		if clk = '1' and clk'event  then
			if reset = '1' then
			Uni1 <= "0000";
			Dec1 <= "0000";
			elsif enable = '1' then
			if Uni1 = "1001" then 
			--resetea el contador cuando la cuenta va en 59
			if Dec1 = "0101" then
			Dec1 <= "0000";
			Uni1 <= "0000";
			ciclo <= '1';
			else
			--pasa a las siguiente decena 
			Uni1 <= "0000";
			Dec1 <= Dec1+1;
			end if;
			--incrementa en 1 las unidades
			else Uni1<=Uni1+1; ciclo <= '0';
			end if;   
		end if;
		end if;
	end process;
	
	--convierte los unsigned en bit_vector´s para poder sacarlos del modulo 
	Dec <= bit_vector(Dec1);
	Uni <= bit_vector(Uni1);
end Behavioral;



