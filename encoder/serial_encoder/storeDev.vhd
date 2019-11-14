LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY flipFlopDPET IS
  PORT (clk, D:     IN STD_LOGIC;
        nSet, nRst: IN STD_LOGIC;
        Q, nQ:      OUT STD_LOGIC);
END flipFlopDPET;

ARCHITECTURE behavior OF flipFlopDPET IS
BEGIN
  PROCESS (clk, nSet, nRst)
  BEGIN
    IF (nRst = '0')
	    THEN Q <= '0';
		      nQ <= '1';
		 ELSIF (nSet = '0')
		       THEN Q <= '1';
		            nQ <= '0';
	          ELSIF (clk = '1') AND (clk'EVENT)
	                THEN Q <= D;
		                  nQ <= NOT D;

	 END IF;
  END PROCESS;
END behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY simpleLogic;
USE simpleLogic.all;

ENTITY binCounter_3bit IS
  PORT (nRst: IN STD_LOGIC;
        clk:  IN STD_LOGIC;
        c:    OUT STD_LOGIC_VECTOR (2 DOWNTO 0));
END binCounter_3bit;

ARCHITECTURE structure OF binCounter_3bit IS
	SIGNAL s_q0, s_q1, s_q2, s_d2: STD_LOGIC;
  COMPONENT gateAnd2
    PORT (x1, x2: IN STD_LOGIC;
          y:      OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT flipFlopDPET
    PORT (clk, D:     IN STD_LOGIC;
          nSet, nRst: IN STD_LOGIC;
          Q, nQ:      OUT STD_LOGIC);
  END COMPONENT;
BEGIN
  ff0: flipFlopDPET PORT MAP (clk, '1', '1', nRst, s_q0);
  ff1: flipFlopDPET PORT MAP (clk, s_q0, '1', s_q0, s_q1);
  q0andq1: gateAnd2 PORT MAP (s_q0, s_q1, s_d2); 
  ff2: flipFlopDPET PORT MAP (clk, s_d2, '1', s_d2, s_q2);
  c <= s_q2 & s_q1 & s_q0;
END structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ParReg_8bit IS
  PORT (nSet: IN STD_LOGIC;
			nRst: IN STD_LOGIC;
        clk: IN STD_LOGIC;
        D: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        Q: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END ParReg_8bit;

ARCHITECTURE structure OF ParReg_8bit IS
    COMPONENT flipFlopDPET
    PORT (clk, D: IN STD_LOGIC;
          nSet, nRst: IN STD_LOGIC;
          Q, nQ: OUT STD_LOGIC);
  END COMPONENT;
BEGIN
  ff0: flipFlopDPET PORT MAP (clk, D(0), nSet, nRst, Q(0));
  ff1: flipFlopDPET PORT MAP (clk, D(1), nSet, nRst, Q(1));
  ff2: flipFlopDPET PORT MAP (clk, D(2), nSet, nRst, Q(2));
  ff3: flipFlopDPET PORT MAP (clk, D(3), nSet, nRst, Q(3));
  ff4: flipFlopDPET PORT MAP (clk, D(4), nSet, nRst, Q(4));
  ff5: flipFlopDPET PORT MAP (clk, D(5), nSet, nRst, Q(5));
  ff6: flipFlopDPET PORT MAP (clk, D(6), nSet, nRst, Q(6));
  ff7: flipFlopDPET PORT MAP (clk, D(7), nSet, nRst, Q(7));

END structure;

