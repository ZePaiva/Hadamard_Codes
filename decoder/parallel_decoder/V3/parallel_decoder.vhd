-- decoder of one bit
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY simpleLogic;
USE simpleLogic.all;

ENTITY mbit_decoder IS
  PORT (i_x0, i_x1, i_x2, i_x3, i_x4, i_x5, i_x6, i_x7: IN  STD_LOGIC;
        o_m: OUT STD_LOGIC;
		  o_v: OUT STD_LOGIC);
END mbit_decoder;

ARCHITECTURE structure OF mbit_decoder IS

	-- signals
	SIGNAL mc: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL mAnd01, mAnd23, mOr01, mOr23: STD_LOGIC;
	SIGNAL mNAnd01, mNAnd23, mNOr01, mNOr23: STD_LOGIC;
	SIGNAL mOneC1, mOneC2, mZeroC1, mZeroC2 : STD_LOGIC;
	SIGNAL mZero, mOne : STD_LOGIC;
	
	-- gates
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
	
BEGIN

	-- beginning xor operations
	mc0    : gateXor2  PORT MAP (i_x0, i_x1, mc(0));
	mc1    : gateXor2  PORT MAP (i_x2, i_x3, mc(1));
	mc2    : gateXor2  PORT MAP (i_x4, i_x5, mc(2));
	mc3    : gateXor2  PORT MAP (i_x6, i_x7, mc(3));

	-- C3-0 equations calculations
	m_And01 : gateAnd2  PORT MAP (mc(1), mc(0), mAnd01);
	m_And23 : gateAnd2  PORT MAP (mc(2), mc(3), mAnd23);
	m_Or01  : gateOr2	 PORT MAP (mc(1), mc(0), mOr01);
	m_Or23	 : gateOr2	 PORT MAP (mc(2), mc(3), mOr23);
	m_NAnd01: gateNand2 PORT MAP (mc(0), mc(1), mNAnd01);
	m_NAnd23: gateNand2 PORT MAP (mc(2), mc(3), mNAnd23);
	m_NOr01 : gateNor2	 PORT MAP (mc(0), mc(1), mNOr01);
	m_NOr23 : gateNor2	 PORT MAP (mc(2), mc(3), mNOr23);
	
	-- One calculations
	m1C1 	 : gateAnd2  PORT MAP (mAnd01, mOr23, mOneC1);
	m1C2 	 : gateAnd2  PORT MAP (mAnd23, mOr01, mOneC2);
	m1		 : gateOr2	 PORT MAP (mOneC1, mOneC2, mOne);
		
	-- Zero calculations
	m0C1 	 : gateAnd2  PORT MAP (mNAnd01, mNOr23, mZeroC1);
	m0C2 	 : gateAnd2  PORT MAP (mNAnd23, mNOr01, mZeroC2);
	m0		 : gateOr2	 PORT MAP (mZeroC1, mZeroC2, mZero);
	
	-- check validity
	mvalid : gateXor2	 PORT MAP (mZero, mOne, o_v);
	
	-- forward one signal
	o_m <= mOne;
	
END structure;


-- complete decoder
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
	SIGNAL m3_o: STD_LOGIC;
	SIGNAL m3_V: STD_LOGIC;
	
	-- decoding computation bits for m2
	SIGNAL m2_o: STD_LOGIC;
	SIGNAL m2_V: STD_LOGIC;
	
	-- decoding computation bits for m1
	SIGNAL m1_o: STD_LOGIC;
	SIGNAL m1_V: STD_LOGIC;
	
	-- decoding computation bits for m0
	SIGNAL m0_o: STD_LOGIC;
	SIGNAL m0_V: STD_LOGIC;
	
	-- gate component
	COMPONENT gateAnd4
		PORT (x1, x2, x3, x4: IN  STD_LOGIC;
				y				  : OUT STD_LOGIC);
	END COMPONENT;
	
	-- concat components
	COMPONENT concatenator4to1
		PORT(x1, x2, x3, x4 : IN  STD_LOGIC;
			  y				  : OUT STD_LOGIC_VECTOR(3 downto 0));
	END COMPONENT;
	
	-- mbit decoder component
	COMPONENT mbit_decoder
		PORT (i_x0, i_x1, i_x2, i_x3, i_x4, i_x5, i_x6, i_x7: IN  STD_LOGIC;
				o_m: OUT STD_LOGIC;
				o_v: OUT STD_LOGIC);
	END COMPONENT;
	
BEGIN

	-- m3 computations
	m3 : mbit_decoder PORT MAP (x(0), x(1), x(2), x(3), x(4), x(5), X(6), x(7), m3_o, m3_v);

	-- m2 computations
	m2	: mbit_decoder PORT MAP (x(0), x(2), x(1), x(3), x(4), x(6), x(5), x(7), m2_o, m2_v);

	-- m1 computations
	m1	: mbit_decoder PORT MAP (x(0), x(4), x(1), x(5), x(2), x(6), x(3), x(7), m1_o, m1_v);

	-- m0 computations
	m0	: mbit_decoder PORT MAP (x(6), m3_o, x(5), m2_o, x(3), m1_o,  '0', x(7), m0_o, m0_v);
	
	-- final results
	concat 	: concatenator4to1 PORT MAP (m3_o, m2_o, m1_o, m0_o, m);
	valid		: gateAnd4 PORT MAP(m3_v, m2_v, m1_v, m0_v, v);
	
END structure;
