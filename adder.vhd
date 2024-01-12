library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity add_sub is

    generic (
        N : integer := 34
        );
    
    port (
        A             : in unsigned(N-1 downto 0);
        B             : in unsigned(N-1 downto 0);
        control       : in std_logic;
        en            : in std_logic;
        Y             : out unsigned(N-1 downto 0) 
        );
end add_sub;

architecture add_sub_1 of add_sub is
    signal output : unsigned(N-1 downto 0);
    begin
        output <= A + B when control = '1' else A - B;
        Y <= output when en='1';
    end architecture;

