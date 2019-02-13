library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_BIT.ALL;

--Modulo Principal del Proyecto
--entradas B1,B2,B3 -> botones, Digito -> Codigo a Ingresar
--salidas RS, RW, EN -> controles para la pantalla LCD
--DATA -> Los datos que se le cargan a la LCD para que muestre los valores.
--Mostrar en que estado va la máquina de estados. 
entity Estacionamiento is 
	port(B1,B2,B3, clkT: in bit;  
	Digito: bit_vector(2 downto 0);
	RS, RW, EN, ControlServo: out bit; 
	DATA: out bit_vector(7 downto 0)
	);
end Estacionamiento;

architecture Behavioral of Estacionamiento is

--Componente para los cronómetros que se generan para contar el tiempo en estacionamiento.
component Reloj8 
	port(ClockT, enableC, resetC: in bit;
		DecHrsF, UniHrsF, DecMinF, UniMinF: out bit_vector(3 downto 0));
end component;   

--component SM2
	--port(ClkD, Enable : in bit; numEntrada : in bit_vector(3 downto 0); numSal: out unsigned(3 downto 0));
--end component;

--Modulo que genera la señal pwm que hace que se levante la pluma del estacionamiento.
component pwmGen 
	port (Posicion, ClkPWM : in bit; SeñalPWM : out bit);
end component;


component LCD1_Module  --Para mostrar Pantalla Principal, que contiene las opciones Salir y Entrar
	port(Clk, rst: in bit; RS, RW, EN: out bit; DATA: out bit_vector(7 downto 0));
end component;

component LCD2_Module  --Para mostrar la pantalla en donde se ingresa el numero.
	port(Clk, rst: in bit; Digito : bit_vector (2 downto 0); RS, RW, EN: out bit; DATA: out bit_vector(7 downto 0));
end component;

component LCD3_Module  --Para mostrar la pantalla que contiene el tiempo en que esta el reloj, asi como también la cantidad a pagar.
	port(Clk, rst: in bit; DecHrs, UniHrs, DecMin, UniMin: in bit_vector(3 downto 0); RS, RW, EN: out bit; DATA: out bit_vector(7 downto 0));
end component;

component LCD4_Module  --Para meter el codigo del carro que se quiere sacar
	port(Clk, rst: in bit;Codigo: in integer range 0 to 3; RS, RW, EN: out bit; DATA: out bit_vector(7 downto 0));
end component;

component LCD5_Module -- Para mostrar en pantalla que ya esta lleno.
	port(Clk, rst: in bit;RS, RW, EN: out bit; DATA: out bit_vector(7 downto 0));
end component;

component DebounceUsar is -- Componente del Debouncer
PORT( CLK: in bit; 
		SIGNALIN: in bit;
		SIGNALOUT: out bit);
end component;

component CLK20HZ is -- Componente para el clock de 20 HZ
	PORT(MCLK: in bit; CLKOUT: out bit);
end component;



signal Boton1, Boton2, Boton3, clockP : bit;
--Boton1: OK.
--Boton2: Salir 
--Boton3: Entrar

--señales para realizar la máquina de estados.
signal Estado, Nextstate : integer range 0 to 5; 

--Rom para guardar los enables y los resets.
type Controles is array (1 to 4, 1 to 2) of bit;  

--Señales Para los cronómetros/relojes que se van a generar.
signal DecHrs1, DecHrs2, DecHrs3, DecHrs4: bit_vector (3 downto 0);
signal UniHrs1, UniHrs2, UniHrs3, UniHrs4: bit_vector (3 downto 0);
signal DecMin1, DecMin2, DecMin3, DecMin4: bit_vector (3 downto 0);
signal UniMin1, UniMin2, UniMin3, UniMin4: bit_vector (3 downto 0);

--type Numero is array (0 to 3) of unsigned(3 downto 0);

--Resets y enables para los cronometros
signal Reset1, Reset2, Reset3, Reset4: bit;
signal ENE1,ENE2,ENE3,ENE4: bit;

--Se genera la ROM para guardar los valores de los resets y el enable
signal Controladores : Controles;  

--
signal ContPass : integer range 0 to 3;

--Señal para cambiar de estado cuando el boton1 está activo.
signal Boton1v : bit;

--Señales para controlar el servo-> Posición tiene 2 opciones: cerrado o abierto. Un reset, y un contador para realizar la operación
signal PosServo, rstServo : bit;
signal contServo: integer range 0 to 500;

--Señales para que funcione el boton1V
signal Risingout, Risingout2 : bit;

--Señales de enable, reset y write para cada uno de los modulos del LCD
signal RS1, RW1, EN1: bit;
signal RS2, RW2, EN2: bit;
signal RS3, RW3, EN3: bit;
signal RS4, RW4, EN4: bit;
signal RS5, RW5, EN5: bit;
signal DATA1: bit_vector(7 downto 0);
signal DATA2: bit_vector(7 downto 0);
signal DATA3: bit_vector(7 downto 0);
signal DATA4: bit_vector(7 downto 0); 
signal DATA5: bit_vector(7 downto 0);

--Señal para cambiar a estado 0 o 1;
signal Botinout: bit_vector(1 downto 0); 


signal ContadorM : integer range 0 to 6;
signal ContadorV : integer range 0 to 3;
signal DecHrsf, UniHrsf, DecMinf, UniMinf: bit_vector(3 downto 0);
--signal uno : bit := '1';
--signal cero : bit := '0';

begin
--Port map para debouncear cada uno de los botones
Debouncer1: DebounceUsar PORT MAP(clockP,B1,Boton1);
Debouncer2: DebounceUsar PORT MAP(clockP,B2,Boton2);
Debouncer3: DebounceUsar PORT MAP(clockP,B3,Boton3);

--Port map para generar un clock para los Modulos del LCD
Clk: CLK20HZ PORT MAP(clkT,clockP);

--Modulos del LCD
LCDInicio: LCD1_Module PORT MAP(clockP, Boton1v, RS1, RW1, EN1, DATA1);
LCDIngresar: LCD2_Module PORT MAP(clockP, Boton2, Digito, RS2, RW2, EN2, DATA2);
LCDDebes: LCD3_Module PORT MAP(clockP, Boton1v, DecHrsf, UniHrsf, DecMinf, UniMinf, RS3, RW3, EN3, DATA3);
LCDCodigo: LCD4_Module PORT MAP(clockP, Boton3, ContadorV, RS4, RW4, EN4, DATA4);
LCDLleno: LCD5_Module PORT MAP(clockP, Boton3, RS5, RW5, EN5, DATA5);

--Relojes para cada coche que entra al estacionamiento. Se muestran en LCD3_Module
Cronometro1: Reloj8 PORT MAP(clockP, ENE1, Reset1, DecHrs1, UniHrs1, DecMin1, UniMin1);
Cronometro2: Reloj8 PORT MAP(clockP, ENE2, Reset2, DecHrs2, UniHrs2, DecMin2, UniMin2);
Cronometro3: Reloj8 PORT MAP(clockP, ENE3, Reset3, DecHrs3, UniHrs3, DecMin3, UniMin3);
Cronometro4: Reloj8 PORT MAP(clockP, ENE4, Reset4, DecHrs4, UniHrs4, DecMin4, UniMin4);

--Port Map del ServoMotor
ServoMotor: pwmGen PORT MAP(posServo, clkT, controlServo);


contadorV <= ContadorM/2;
--Función para mandar a otro estado
Botinout <= B2&B3;

--MUX para seleccionar el enable correspondiente cuando la pantalla esté en el modulo indicado.
with Estado Select
		EN <= EN1 when 0,  
				EN4 when 4,
				EN2 when 2,
				EN3 when 3,
				EN5 when 5,
				'0' when others;

--MUX para seleccionar el Reset correspondiente
with Estado Select
		RS <= 	RS1 when 0,  
					RS4 when 4,
					RS2 when 2,
					RS3 when 3,
					RS5 when 5,
					'0' when others;

--El RW siempre va a ser 0
RW <= '0';

--MUX para seleccionar la DATA correspondiente para escribir.
with Estado Select
		DATA <= 	DATA1 when 0,  
					DATA4 when 4,
					DATA2 when 2,
					DATA3 when 3,
					DATA5 when 5,
					"00000000" when others;
		
		
--Con el digito, se selecciona la señal correcta de las decenas de las horas para mandar al módulo LCD.
with to_integer(unsigned(Digito)) Select
		DecHrsf <= DecHrs1 when 0,
					  DecHrs2 when 1,
					  DecHrs3 when 2,
					  DecHrs4 when 3,
					  "0000" when others;
					  
--Con el digito, se selecciona la señal correcta de las decenas de los minutos para mandar al módulo LCD.
with to_integer(unsigned(Digito)) Select
		DecMinf <= DecMin1 when 0,
					  DecMin2 when 1,
					  DecMin3 when 2,
					  DecMin4 when 3,
					  "0000" when others;
					  
--Con el digito, se selecciona la señal correcta de las Unidades de las horas para mandar al módulo LCD.
with to_integer(unsigned(Digito)) Select
		UniHrsf <= UniHrs1 when 0,
					  UniHrs2 when 1,
					  UniHrs3 when 2,
					  UniHrs4 when 3,
					  "0000" when others;

--Con el digito, se selecciona la señal correcta de las Unidades 
--de los minutos para mandar al módulo LCD.
with to_integer(unsigned(Digito)) Select
		UniMinf <= UniMin1 when 0,
					  UniMin2 when 1,
					  UniMin3 when 2,
					  UniMin4 when 3,
					  "0000" when others;
						
					
--Los enables toman los valores que hay en la ROM
ENE1 <= Controladores(1,2);
ENE2 <= Controladores(2,2);
ENE3 <= Controladores(3,2);
ENE4 <= Controladores(4,2);

--Los resets toman los valores que están guardados en la ROM
Reset1 <= Controladores(1,1);
Reset2 <= Controladores(2,1);
Reset3 <= Controladores(3,1);
Reset4 <= Controladores(4,1);

--Process que lleva a cabo la máquina de estados
Process(clockP, Estado)

begin 
	
	if clockP ='1' and clockP'event then
		--Case que va a cambiar los estados.
		case Estado is
		--Cuando el estado es 0, se tienen 2 opciones: Entrar o Salir. Se asignan los valores correspondientes a la ROM y se hace el giro del servo.
		--Dependiendo de la entrada del botón se va al siguiente estado. 
		when 0 =>
		rstServo <= '0';
		Controladores(1,1) <= '0';
		Controladores(2,1) <= '0';
		Controladores(3,1) <= '0';
		Controladores(4,1) <= '0';
		
		Controladores(1,2) <= '1';
		Controladores(2,2) <= '1';
		Controladores(3,2) <= '1';
		Controladores(4,2) <= '1';	
		
			case botinout is 
			when "01" => Nextstate <= 1;
			when "10" => Nextstate <= 2;
			when others => NextState <= 0;
			end case;
		
		--Cuando el estado es uno, se ingresa un carro si es que no esta lleno el estacionamiento. Dependiendo de esto, se va al estado de la LCD correspondiente.
	
		when 1 =>
		if ContadorM < 6 then
		ContadorM <= ContadorM + 1; 
		Nextstate <= 4;
		else 
		ContadorM <= ContadorM;
		Nextstate <= 5;
		end if;
		Controladores(1,1) <= '0';
		Controladores(2,1) <= '0';
		Controladores(3,1) <= '0';
		Controladores(4,1) <= '0';
		
		Controladores(1,2) <= '1';
		Controladores(2,2) <= '1';
		Controladores(3,2) <= '1';
		Controladores(4,2) <= '1';	
		
		
		--Cuando está en el estado 2, el carro esta saliendo, por lo que empieza a contar y se va al contador 3 hasta que metas un carro que esta estacionado
		when 2 =>
		
		Controladores(1,1) <= '0';
		Controladores(2,1) <= '0';
		Controladores(3,1) <= '0';
		Controladores(4,1) <= '0';
		
		Controladores(1,2) <= '1';
		Controladores(2,2) <= '1';
		Controladores(3,2) <= '1';
		Controladores(4,2) <= '1';	
		
		if Boton1v = '1' and to_integer(unsigned(Digito)) <= ContadorV then NextState <= 3;
		else Nextstate <= 2;
		end if;		
		rstServo <= '0';
		
		--Cuando esta en el estado 3, se muestra el tiempo, se muestra el tiempo y la cantidad a pagar, 
		--y se resta la cantidad de carros en el estacionamiento, lo que hace que la pluma suba.
		when 3 =>
		Controladores(1,1) <= '0';
		Controladores(2,1) <= '0';
		Controladores(3,1) <= '0';
		Controladores(4,1) <= '0';
		
		Controladores(ContadorV, 2) <= '0';
		Controladores(ContadorV+1, 2) <= '1';
		Controladores(ContadorV+2, 2) <= '1';
		Controladores(ContadorV+3, 2) <= '1';

		if Boton1v = '1' then NextState <= 0;
		else Nextstate <= 3;
		end if;		
		
		rstServo <= '1';
		
		if ContadorM = 0 then 
		ContadorM <= ContadorM;
		else
		ContadorM <= ContadorM - 1;
		end if;
	
		--Estado que muestra el codigo mientras no se presione el boton de ok (boton 1)
		when 4 =>
		
		rstServo <= '1';
		
		Controladores(1,2) <= '1';
		Controladores(2,2) <= '1';
		Controladores(3,2) <= '1';
		Controladores(4,2) <= '1';
		
		Controladores(ContadorV, 1) <= '1';
		Controladores(ContadorV+1, 1) <= '0';
		Controladores(ContadorV+2, 1) <= '0';
		Controladores(ContadorV+3, 1) <= '0';
		
		if Boton1v = '1' then NextState <= 0;
		else Nextstate <= 4;
		end if;
		ContadorM <= ContadorM; 
		
		--Muestra lleno si está lleno. 
		when 5 =>
		if Boton1v = '1' then NextState <= 0;
		else Nextstate <= 5;
		end if;
		
		when others => Nextstate <= 0; 
	
	end case;
	end if;
end process;

--Process para cambiar el estado para la máquina de estados.
Process(clockP)
begin 
	if clockP ='1' and clockP'event then
	Estado <= NextState;
end if;
end process;

--Process Para el funcionamiento correcto del boton1
Process(ClockP)
begin
	if clockP = '1' and clockP'event then 
	Risingout <= Boton1;
	Risingout2 <= Risingout;
end if;
end Process;

--Código para el cambio en el servo. 
Process(ClockP)
begin 
	if clockP = '1' and clockP'event then
	if rstServo = '1' then
	contServo <= 0;
	elsif contServo < 500 then 
	contServo <= contServo+1;
	PosServo <= '1';
	else 
	contServo <= ContServo;
	PosServo <= '0';
end if;
end if;
end process;

boton1v <= (not Risingout2) and Boton1; 



end Behavioral;
