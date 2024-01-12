library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity inp_BarrelShifter is
  generic(
    N       :       integer := 64
  );
  port(
    A       :in      unsigned(N-1 downto 0);
    shift   :in      std_logic;
    Y       :out     unsigned(N-1 downto 0)
  );
end entity inp_BarrelShifter;

architecture rtl of inp_BarrelShifter is
    signal shiftedVector : unsigned(N-1 downto 0);
begin
    shiftedVector(N-1 downto 0) <= A(N-3 downto 0) & "00";
    Y <= shiftedVector when shift='1' else A;

end architecture rtl;
