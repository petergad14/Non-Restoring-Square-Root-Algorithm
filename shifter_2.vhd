library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity out_BarrelShifter is
  generic(
    N       :       integer := 32
  );
  port(
    A       :in      unsigned(N-1 downto 0);
    inpu     :in      std_logic;
    shift   :in      std_logic;
    Y       :out     unsigned(N-1 downto 0)
  );
end entity out_BarrelShifter;

architecture rtl of out_BarrelShifter is
    signal shiftedVector : unsigned(N-1 downto 0);
begin
    shiftedVector(N-1 downto 0) <= A(N-2 downto 0) & not(inpu);
    Y <= shiftedVector when shift='1' else A;
end architecture rtl;
