library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity square_root_comb is

    generic (
        N : integer := 32  -- Number of bits for output
        );
    
    port (
        A               : in unsigned((2*N) - 1 downto 0);  -- Input data 
        Result          : out unsigned(N - 1 downto 0)     -- Square root output
        );
end square_root_comb;