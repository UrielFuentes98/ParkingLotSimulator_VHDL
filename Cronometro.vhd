library IEEE;

--modulo que define al reloj programable en formato de 24 horas.

entity Reloj8 is
	--Clock: reloj interno del cronometro, enableC: habilitador del cronometro
	--resetC: reset del conometro.
	--DecHrsF, UniHrsF, DecMinF, UniMinF: salidas del cronometro. 
	port(ClockT, enableC, resetC: in bit;
		DecHrsF, UniHrsF, DecMinF, UniMinF: out bit_vector(3 downto 0));
end Reloj8;   
 
architecture Behavioral of Reloj8 is

--componente del contador para las horas
component Counter24 
port(reset,enable, clk  : in bit; Dec, Uni : out bit_vector(3 downto 0));
end component; 
--componente del contador para los minutos y segundos
component MOD60  
port(reset,enable, clk  : in bit; ciclo: out bit; Dec, Uni : out bit_vector(3 downto 0));
end component; 

--señal para poner los contadores en cascada
signal CLKmin, CLKhrs: bit;

--señales para guardar la informacion de los segundos que no será utilizada. 
signal trashB, trashB1 : bit_vector (3 downto 0);

begin  

--generador de los segundos y del reloj para el modulo de los minutos
segundos : Mod60 port map (resetC,enableC,ClockT,CLKmin,trashB,trashB1);
--generador de los minutos y del reloj para el modulo de las horas
minutos : Mod60 port map (resetC,enableC,CLKmin,CLKhrs,DecMinF,UniMinF);
--generador de las horas
horas : Counter24 port map (resetC,enableC,CLKhrs, DecHrsF, UniHrsF);


				 
end Behavioral;