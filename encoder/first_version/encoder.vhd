LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY encoder IS
  PORT (m: IN STD_LOGIC_VECTOR(3 downto 0);
        o:   OUT STD_LOGIC_VECTOR(7 downto 0));
END encoder;

ARCHITECTURE structure OF encoder IS
SIGNAL s0, s1, s2, s3, s4, s5, s6, s7: STD_LOGIC;
BEGIN
	s7 <= m(0);
	s6 <= m(3) xor m(0);
	s5 <= m(2) xor m(0);
	s4 <= m(3) xor s5;
	s3 <= m(1) xor m(0);
	s2 <= m(3) xor s3;
	s1 <= m(2) xor s3;
	s0 <= m(3) xor s1;
	o <= s7 & s6 & s5 & s4 & s3 & s2 & s1 & s0;
END structure;
