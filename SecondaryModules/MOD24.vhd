--modulo de contador modulo 24 para llevar la cuenta de las horas en formato de 24 horas

library IEEE;
use IEEE.numeric_bit.all;

entity Counter24 is
--clk: reloj del contador, Dec: bit_vector que representa las decenas de la hora, Uni: bit_vector
--que representa las unidades de la hora.
	port(reset,enable , clk: in bit; Dec, Uni : out bit_vector(3 downto 0));
end Counter24;

architecture Behavioral of Counter24 is
	--Dec1: unsigned interno para guardar el valor de las decenas
	--Uni1: unsigned interno para guardar el valor de las unidades.
	signal Dec1, Uni1 : unsigned(3 downto 0);
begin
	
	--process que lleva a cabo el contador
	process(clk)
		begin 
		--el contador trabaja en transicion positiva
		if reset = '1' then 
		--se resetea el contador
		Uni1 <= "0000";
		Dec1 <= "0000";
		elsif enable = '1' then
		if clk = '1' and clk'event then
			if Uni1 = "1001" then 
			--cuando las unidades llegan a 9 se pasa a una nueva decena
			Uni1 <= "0000";
			Dec1 <= Dec1+1;
			--cuando se llega a 24 se recetea el contador
			elsif Dec1 = "0010" and Uni1 = "0011" then 
			Dec1 <= "0000";
			Uni1 <= "0000";
			--se incrementa en 1 las unidades
			else Uni1<=Uni1+1;
			end if;
			end if;
			end if;
	end process;
	
	--transforma los unsigned en bit_vector´s para poderlos sacar del modulo. 
	Dec <= bit_vector(Dec1);
	Uni <= bit_vector(Uni1);
end Behavioral;