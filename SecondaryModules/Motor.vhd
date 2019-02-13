library IEEE;
use IEEE.numeric_bit.all;

entity pwmGen is
	port (botonAn, ClkPWM : in bit; SeñalPWM : out bit; S8 : out bit_vector(7 downto 0); EN : out bit_vector(3 downto 0));
end pwmGen;

architecture Behavioral of pwmGen is

component DebounceUsar is -- Componente del debounce.
 Port(CLK, SIGNALIN: IN BIT; SIGNALOUT: OUT BIT); 
end component;


component DISPLAY IS
	PORT (
		CLK : IN BIT;
		D3 : IN BIT_VECTOR(3 DOWNTO 0);
		D2 : IN BIT_VECTOR(3 DOWNTO 0);
		D1 : IN BIT_VECTOR(3 DOWNTO 0);
		D0 : IN BIT_VECTOR(3 DOWNTO 0);
		S8 : OUT BIT_VECTOR (7 DOWNTO 0);
		EN : OUT BIT_VECTOR(3 DOWNTO 0)
	);
END component; -- componente del display

component CLK_rapHZ IS -- Componente que hace un reloj para el display
	PORT (
		MCLK : IN BIT;
		CLKOUT : OUT BIT);
END component;


component CLK50HZ IS -- Reloj de 50 HZ
	PORT (
		MCLK : IN BIT;
		CLKOUT : OUT BIT);
END component;

signal C : bit; -- El clock del display
signal rango : integer range 0 to 999_999; --el rango para el pwm. 1 millón de pulsos de reloj
signal multiplo : integer range 0 to 4; -- el multiplo para obtener la salida deseada.
signal botInt, CLK50 : bit; -- señal para el reloj de 59 y para el botón
type matrix is array (0 to 4, 0 to 2) of bit_vector(3 downto 0);
signal nums : matrix := (("0000", "0000", "0000"), ("0000", "0100", "0101"), ("0000", "1001", "0000"), ("0001", "0011", "0101"), ("0001", "1000", "0000"));-- matriz que contiene los numeros que se van a poner en el display- 
signal cent, dec, uni : bit_vector (3 downto 0); -- la entrada del display
signal cero : bit_vector(3 downto 0); -- Para poner en el display que sobra un 0


begin 
  
cero <= "0000";
  
debounce1 : DebounceUsar port map (CLK50,botonAn,botInt); -- Para el debounce del botón
disp1 : Display port map (C, cero, cent, dec, uni, S8, EN); -- Para el display.
cambclock : CLK_rapHZ port map(ClkPWM, C); -- El clock que va a entrar en el display.
clkdebounce : CLK50HZ port map(ClkPWM, CLK50); -- Clock del debounce.


process (ClkPWM) --Lo que genera el pulso PWM
begin
if ClkPWM = '1' and ClkPWM'event then
if rango = 999_999 then 
rango <= 0;
else
rango <= rango + 1;
end if;
end if;
end process; 

process (botInt) --Lo que hace que cambie el múltiplo, que es cuando se aprieta el botón.
begin 
if botInt = '1' and botInt'event then
if multiplo = 4 then multiplo <= 0;
else 
multiplo <= multiplo + 1; 
end if;
end if;  
end process;  
    
SeñalPWM <= '1' when rango < (40_000 + (multiplo *20_000)) else '0'; -- Lo que genera que gire el motor dependindo del ancho de pulso.

cent <= nums(multiplo, 0); -- le asigna lo que hay en la matriz para el display.
dec <= nums(multiplo, 1);
uni <= nums(multiplo, 2);

end Behavioral;