LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY parallel_decoder IS
  PORT (x: IN STD_LOGIC_VECTOR(7 downto 0);
        m: OUT STD_LOGIC_VECTOR(3 downto 0);
		  v: OUT STD_LOGIC);
END parallel_decoder;

ARCHITECTURE structure OF parallel_decoder IS
	
	-- decoding computation bits for m3
	SIGNAL m3_c: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL m3_z: STD_LOGIC;
	SIGNAL m3_o: STD_LOGIC;
	SIGNAL m3_V: STD_LOGIC;
	
	-- decoding computation bits for m2
	SIGNAL m2_c: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL m2_z: STD_LOGIC;
	SIGNAL m2_o: STD_LOGIC;
	SIGNAL m2_V: STD_LOGIC;
	
	-- decoding computation bits for m1
	SIGNAL m1_c: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL m1_z: STD_LOGIC;
	SIGNAL m1_o: STD_LOGIC;
	SIGNAL m1_V: STD_LOGIC;
	
	-- decoding computation bits for m0
	SIGNAL m0_c: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL m0_z: STD_LOGIC;
	SIGNAL m0_o: STD_LOGIC;
	SIGNAL m0_V: STD_LOGIC;
	
BEGIN

	m3_c(0) <= x(0) xor x(1);
	m3_c(1) <= x(2) xor x(3);
	m3_c(2) <= x(4) xor x(5);
	m3_c(3) <= x(6) xor x(7);
	m3_o    <= (m3_c(1) and m3_c(0) and (m3_c(3) or m3_c(2))) or (m3_c(3) and m3_c(2) and (m3_c(1) or m3_c(0)));
	m3_z    <= (not (m3_c(1) or m3_c(0)) and not (m3_c(3) and m3_c(2))) or (not (m3_c(3) or m3_c(2)) and not (m3_c(1) and m3_c(0)));
	m3_v	  <= m3_z xor m3_o;

	m2_c(0) <= x(0) xor x(2);
	m2_c(1) <= x(1) xor x(3);
	m2_c(2) <= x(4) xor x(6);
	m2_c(3) <= x(5) xor x(7);
	m2_o    <= (m2_c(1) and m2_c(0) and (m2_c(3) or m2_c(2))) or (m2_c(3) and m2_c(2) and (m2_c(1) or m2_c(0)));
	m2_z    <= (not (m2_c(1) or m2_c(0)) and not (m2_c(3) and m2_c(2))) or (not (m2_c(3) or m2_c(2)) and not (m2_c(1) and m2_c(0)));
	m2_v	  <= m2_z xor m2_o;

	m1_c(0) <= x(0) xor x(4);
	m1_c(1) <= x(1) xor x(5);
	m1_c(2) <= x(2) xor x(6);
	m1_c(3) <= x(4) xor x(7);
	m1_o    <= (m1_c(1) and m1_c(0) and (m1_c(3) or m1_c(2))) or (m1_c(3) and m1_c(2) and (m1_c(1) or m1_c(0)));
	m1_z    <= (not (m1_c(1) or m1_c(0)) and not (m1_c(3) and m1_c(2))) or (not (m1_c(3) or m1_c(2)) and not (m1_c(1) and m1_c(0)));
	m1_v	  <= m1_z xor m1_o;

	m0_c(0) <= x(6) xor m3_o;
	m0_c(1) <= x(5) xor m2_o;
	m0_c(2) <= x(4) xor m1_o;
	m0_c(3) <= x(7);
	m0_o    <= (m0_c(1) and m0_c(0) and (m0_c(3) or m0_c(2))) or (m0_c(3) and m0_c(2) and (m0_c(1) or m0_c(0)));
	m0_z    <= (not (m0_c(1) or m0_c(0)) and not (m0_c(3) and m0_c(2))) or (not (m0_c(3) or m0_c(2)) and not (m0_c(1) and m0_c(0)));
	m0_v	  <= m0_z xor m0_o;
	
	m <= m3_o & m2_o & m1_o & m0_o;
	v <= m3_v and m2_v and m1_v and m0_v;
	
END structure;