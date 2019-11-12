LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY decoder IS
  PORT (y: IN STD_LOGIC_VECTOR(7 downto 0);
        m: OUT STD_LOGIC_VECTOR(3 downto 0);
		  v: OUT STD_LOGIC);
END decoder;

ARCHITECTURE structure OF decoder IS
	SIGNAL m0, m1, m2, m3: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL muxOut0, muxOut1, muxOut2, muxOut3: STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL c0, c1, c2, c3: STD_LOGIC_VECTOR (2 DOWNTO 0);
	COMPONENT popCounter_4bit
		PORT (d: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				c: OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;
	COMPONENT multiplexer
		PORT (sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				mBit: OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
	END COMPONENT;
BEGIN
	m3 <= (y(6) xor y(7)) & (y(4) xor y(5)) & (y(2) xor y(3)) & (y(0) xor y(1));
	m2 <= (y(5) xor y(7)) & (y(4) xor y(6)) & (y(1) xor y(3)) & (y(0) xor y(2));
	m1 <= (y(3) xor y(7)) & (y(2) xor y(6)) & (y(1) xor y(5)) & (y(0) xor y(4));
	m0 <= y(7) & (y(6) xor muxOut3(0)) & (y(5) xor muxOut2(0)) & (y(3) xor muxOut1(0));

	popC3: popCounter_4bit PORT MAP (d=>m3, c=>c3);
	popC2: popCounter_4bit PORT MAP (d=>m2, c=>c2);
	popC1: popCounter_4bit PORT MAP (d=>m1, c=>c1);
	popC0: popCounter_4bit PORT MAP (d=>m0, c=>c0);

	
	mux3: multiplexer PORT MAP(sel=>c3, mBit=>muxOut3);
	mux2: multiplexer PORT MAP(sel=>c2, mBit=>muxOut2);
	mux1: multiplexer PORT MAP(sel=>c1, mBit=>muxOut1);
	mux0: multiplexer PORT MAP(sel=>c0, mBit=>muxOut0);
	
	m <= muxOut3(0) & muxOut2(0) & muxOut1(0) & muxOut0(0);
	v <= muxOut3(1) and muxOut2(1) and muxOut1(1) and muxOut0(1);
	
END structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY popCounter_4bit IS
  PORT (d: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        c: OUT STD_LOGIC_VECTOR (2 DOWNTO 0));
END popCounter_4bit;

ARCHITECTURE structure OF popCounter_4bit IS
BEGIN
  c(0) <= (d(3) XOR d(2)) XOR (d(1) XOR d(0));
  c(1) <= ((d(3) XOR d(2)) AND (d(1) OR d(0))) OR ((d(3) AND d(2)) AND (d(1) NAND d(0))) OR (d(3) NOR (d(1) NAND d(0)));
  c(2) <= (d(3) AND d(2)) AND (d(1) AND d(0));
END structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY multiplexer IS
  PORT (sel: 	IN STD_LOGIC_VECTOR(2 downto 0);
        mBit:	OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END multiplexer;

ARCHITECTURE structure OF multiplexer IS
BEGIN
	WITH sel SELECT mBit <= 	
					"10" WHEN "000",
					"10" WHEN "001",
					"00" WHEN "010",
					"11" WHEN "011",
					"11" WHEN "100",
					"01" WHEN OTHERS;
	
END structure;