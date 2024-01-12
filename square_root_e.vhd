library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_pkg.all;

entity square_root is

    generic (
        N : integer := 32  -- Number of bits for output
        );
    
    port (
        clk             : in std_logic;                   -- Clock input
        rst             : in std_logic;                   -- Reset input
        start           : in std_logic;                   -- Start calculation signal
        A               : in unsigned((2*N) - 1 downto 0);  -- Input data 
        Result          : out unsigned(N - 1 downto 0);     -- Square root output
        finished        : out std_logic                   -- 1 When calculation is done
        );
end square_root;
