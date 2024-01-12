library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity a3_tb is
end a3_tb;

architecture simulation_tb of a3_tb is

    component square_root_comb is
        generic(N : integer := 32);
        port (
            A               : in unsigned((2*N) - 1 downto 0);  -- Input data 
            Result          : out unsigned(N - 1 downto 0)   -- Square root output
        );
    end component;
    
    constant N : integer := 32;
    signal inp_tb : unsigned((2*N)-1 downto 0) := (others => '0');
    signal result_tb : unsigned(N - 1 downto 0);

begin

    --entity instantiation.
    DUT : entity work.square_root_comb(a3) generic map(N => N)
             port map(inp_tb, result_tb);

    process
    begin
        inp_tb <= to_unsigned(0, 64);
        wait for 30 ps;
        inp_tb <= to_unsigned(1, 64);
        wait for 30 ps;
        inp_tb <= to_unsigned(512, 64);
        wait for 30 ps;
        inp_tb <= to_unsigned(5499030, 64);
        wait for 30 ps;
        inp_tb <= to_unsigned(1194877489, 64);

        report "Simulation finished";
        wait;
    end process;

end architecture;