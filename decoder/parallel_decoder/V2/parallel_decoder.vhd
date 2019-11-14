LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY simpleLogic;
USE simpleLogic.all;

ENTITY parallel_decoder IS
  PORT (x: IN STD_LOGIC_VECTOR(7 downto 0);
        m: OUT STD_LOGIC_VECTOR(3 downto 0);
		  v: OUT STD_LOGIC);
END parallel_decoder;

ARCHITECTURE structure OF parallel_decoder IS
	
	-- decoding computation bits for m3
	SIGNAL m3_c: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL m3_A01, m3_A23, m3_O01, m3_O23: STD_LOGIC;
	SIGNAL m3_NA01, m3_NA23, m3_NO01, m3_NO23: STD_LOGIC;
	SIGNAL m3_oC1, m3_oC2, m3_zC1, m3_zC2 : STD_LOGIC;
	SIGNAL m3_z: STD_LOGIC;
	SIGNAL m3_o: STD_LOGIC;
	SIGNAL m3_V: STD_LOGIC;
	
	-- decoding computation bits for m2
	SIGNAL m2_c: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL m2_A01, m2_A23, m2_O01, m2_O23: STD_LOGIC;
	SIGNAL m2_NA01, m2_NA23, m2_NO01, m2_NO23: STD_LOGIC;
	SIGNAL m2_oC1, m2_oC2, m2_zC1, m2_zC2 : STD_LOGIC;
	SIGNAL m2_z: STD_LOGIC;
	SIGNAL m2_o: STD_LOGIC;
	SIGNAL m2_V: STD_LOGIC;
	
	-- decoding computation bits for m1
	SIGNAL m1_c: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL m1_A01, m1_A23, m1_O01, m1_O23: STD_LOGIC;
	SIGNAL m1_NA01, m1_NA23, m1_NO01, m1_NO23: STD_LOGIC;
	SIGNAL m1_oC1, m1_oC2, m1_zC1, m1_zC2 : STD_LOGIC;
	SIGNAL m1_z: STD_LOGIC;
	SIGNAL m1_o: STD_LOGIC;
	SIGNAL m1_V: STD_LOGIC;
	
	-- decoding computation bits for m0
	SIGNAL m0_c: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL m0_A01, m0_A23, m0_O01, m0_O23: STD_LOGIC;
	SIGNAL m0_NA01, m0_NA23, m0_NO01, m0_NO23: STD_LOGIC;
	SIGNAL m0_oC1, m0_oC2, m0_zC1, m0_zC2 : STD_LOGIC;
	SIGNAL m0_z: STD_LOGIC;
	SIGNAL m0_o: STD_LOGIC;
	SIGNAL m0_V: STD_LOGIC;
	
	-- gates components
	COMPONENT gateXor2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT gateNor2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;	
	COMPONENT gateNand2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT gateAnd2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT gateOr2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT gateAnd4
		PORT (x1, x2, x3, x4: IN  STD_LOGIC;
				y				  : OUT STD_LOGIC);
	END COMPONENT;
	
	-- concat component
	COMPONENT concatenator4to1
		PORT(x1, x2, x3, x4 : IN  STD_LOGIC;
			  y				  : OUT STD_LOGIC_VECTOR(3 downto 0));
	END COMPONENT;
	
BEGIN

	-- m3 computations
	m3_c0    : gateXor2  PORT MAP (x(0), x(1), m3_c(0));
	m3_c1    : gateXor2  PORT MAP (x(2), x(3), m3_c(1));
	m3_c2    : gateXor2  PORT MAP (x(4), x(5), m3_c(2));
	m3_c3    : gateXor2  PORT MAP (x(6), x(7), m3_c(3));
	m3_And01 : gateAnd2  PORT MAP (m3_c(1), m3_c(0), m3_A01);
	m3_And23 : gateAnd2  PORT MAP (m3_c(2), m3_c(3), m3_A23);
	m3_Or01  : gateOr2	PORT MAP (m3_c(1), m3_c(0), m3_O01);
	m3_Or23	: gateOr2	PORT MAP (m3_c(2), m3_c(3), m3_O23);
	m3_NAnd01: gateNand2 PORT MAP (m3_c(0), m3_c(1), m3_NA01);
	m3_NAnd23: gateNand2 PORT MAP (m3_c(2), m3_c(3), m3_NA23);
	m3_NOr01 : gateNor2	PORT MAP (m3_c(0), m3_c(1), m3_NO01);
	m3_NOr23 : gateNor2	PORT MAP (m3_c(2), m3_c(3), m3_NO23);
	m3_1C1 	: gateAnd2  PORT MAP (m3_A01, m3_O23, m3_oC1);
	m3_1C2 	: gateAnd2  PORT MAP (m3_A23, m3_O01, m3_oC2);
	m3_0C1 	: gateAnd2  PORT MAP (m3_NA01, m3_NO23, m3_zC1);
	m3_0C2 	: gateAnd2  PORT MAP (m3_NA23, m3_NO01, m3_zC2);
	m3_1		: gateOr2	PORT MAP (m3_oC1, m3_oC2, m3_o);
	m3_0		: gateOr2	PORT MAP (m3_zC1, m3_zC2, m3_z);
	m3_valid : gateXor2	PORT MAP (m3_o, m3_z, m3_v);

	-- m2 computations
	m2_c0  	: gateXor2  PORT MAP (x(0), x(1), m2_c(0));
	m2_c1    : gateXor2  PORT MAP (x(2), x(3), m2_c(1));
	m2_c2    : gateXor2  PORT MAP (x(4), x(5), m2_c(2));
	m2_c3    : gateXor2  PORT MAP (x(6), x(7), m2_c(3));
	m2_And01 : gateAnd2  PORT MAP (m2_c(1), m2_c(0), m2_A01);
	m2_And23 : gateAnd2  PORT MAP (m2_c(2), m2_c(3), m2_A23);
	m2_Or01  : gateOr2	PORT MAP (m2_c(1), m2_c(0), m2_O01);
	m2_Or23	: gateOr2	PORT MAP (m2_c(2), m2_c(3), m2_O23);
	m2_NAnd01: gateNand2 PORT MAP (m2_c(0), m2_c(1), m2_NA01);
	m2_NAnd23: gateNand2 PORT MAP (m2_c(2), m2_c(3), m2_NA23);
	m2_NOr01 : gateNor2	PORT MAP (m2_c(0), m2_c(1), m2_NO01);
	m2_NOr23 : gateNor2	PORT MAP (m2_c(2), m2_c(3), m2_NO23);
	m2_1C1 	: gateAnd2  PORT MAP (m2_A01, m2_O23, m2_oC1);
	m2_1C2 	: gateAnd2  PORT MAP (m2_A23, m2_O01, m2_oC2);
	m2_0C1 	: gateAnd2  PORT MAP (m2_NA01, m2_NO23, m2_zC1);
	m2_0C2 	: gateAnd2  PORT MAP (m2_NA23, m2_NO01, m2_zC2);
	m2_1		: gateOr2	PORT MAP (m2_oC1, m2_oC2, m2_o);
	m2_0		: gateOr2	PORT MAP (m2_zC1, m2_zC2, m2_z);
	m2_valid : gateXor2	PORT MAP (m2_o, m2_z, m2_v);

	-- m1 computations
	m1_c0 	: gateXor2  PORT MAP (x(0), x(4), m1_c(0));
	m1_c1 	: gateXor2  PORT MAP (x(1), x(5), m1_c(1));
	m1_c2 	: gateXor2  PORT MAP (x(2), x(6), m1_c(2));
	m1_c3 	: gateXor2  PORT MAP (x(3), x(7), m1_c(3));
	m1_And01 : gateAnd2  PORT MAP (m1_c(1), m1_c(0), m1_A01);
	m1_And23 : gateAnd2  PORT MAP (m1_c(2), m1_c(3), m1_A23);
	m1_Or01  : gateOr2	PORT MAP (m1_c(1), m1_c(0), m1_O01);
	m1_Or23	: gateOr2	PORT MAP (m1_c(2), m1_c(3), m1_O23);
	m1_NAnd01: gateNand2 PORT MAP (m1_c(0), m1_c(1), m1_NA01);
	m1_NAnd23: gateNand2 PORT MAP (m1_c(2), m1_c(3), m1_NA23);
	m1_NOr01 : gateNor2	PORT MAP (m1_c(0), m1_c(1), m1_NO01);
	m1_NOr23 : gateNor2	PORT MAP (m1_c(2), m1_c(3), m1_NO23);
	m1_1C1 	: gateAnd2  PORT MAP (m1_A01, m1_O23, m1_oC1);
	m1_1C2 	: gateAnd2  PORT MAP (m1_A23, m1_O01, m1_oC2);
	m1_0C1 	: gateAnd2  PORT MAP (m1_NA01, m1_NO23, m1_zC1);
	m1_0C2 	: gateAnd2  PORT MAP (m1_NA23, m1_NO01, m1_zC2);
	m1_1		: gateOr2	PORT MAP (m1_oC1, m1_oC2, m1_o);
	m1_0		: gateOr2	PORT MAP (m1_zC1, m1_zC2, m1_z);
	m1_valid : gateXor2	PORT MAP (m1_o, m1_z, m1_v);

	-- m0 computations
	m0_c0 	: gateXor2  PORT MAP (x(6), m3_o, m0_c(0));
	m0_c1 	: gateXor2  PORT MAP (x(5), m2_o, m0_c(1));
	m0_c2 	: gateXor2  PORT MAP (x(4), m1_o, m0_c(2));
	m0_c3    : gateXor2  PORT MAP (x(7), x(7), m0_c(3));
	m0_And01 : gateAnd2  PORT MAP (m0_c(1), m0_c(0), m0_A01);
	m0_And23 : gateAnd2  PORT MAP (m0_c(2), m0_c(3), m0_A23);
	m0_Or01  : gateOr2	PORT MAP (m0_c(1), m0_c(0), m0_O01);
	m0_Or23	: gateOr2	PORT MAP (m0_c(2), m0_c(3), m0_O23);
	m0_NAnd01: gateNand2 PORT MAP (m0_c(0), m0_c(1), m0_NA01);
	m0_NAnd23: gateNand2 PORT MAP (m0_c(2), m0_c(3), m0_NA23);
	m0_NOr01 : gateNor2	PORT MAP (m0_c(0), m0_c(1), m0_NO01);
	m0_NOr23 : gateNor2	PORT MAP (m0_c(2), m0_c(3), m0_NO23);
	m0_1C1 	: gateAnd2  PORT MAP (m0_A01, m0_O23, m0_oC1);
	m0_1C2 	: gateAnd2  PORT MAP (m0_A23, m0_O01, m0_oC2);
	m0_0C1 	: gateAnd2  PORT MAP (m0_NA01, m0_NO23, m0_zC1);
	m0_0C2 	: gateAnd2  PORT MAP (m0_NA23, m0_NO01, m0_zC2);
	m0_1		: gateOr2	PORT MAP (m0_oC1, m0_oC2, m0_o);
	m0_0		: gateOr2	PORT MAP (m0_zC1, m0_zC2, m0_z);
	m0_valid : gateXor2	PORT MAP (m0_o, m0_z, m0_v);

	
	concat 	: concatenator4to1 PORT MAP (m3_o, m2_o, m1_o, m0_o, m);
	valid		: gateAnd4 PORT MAP(m3_v, m2_v, m1_v, m0_v, v);
	
END structure;
