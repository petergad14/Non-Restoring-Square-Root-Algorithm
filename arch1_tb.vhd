library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_pkg.all;


--empty entity as its a testbench
entity newton_tb is
end newton_tb;

architecture simulation of newton_tb is

    --Declare the component which we want to test.
    component newton_method is
        generic(N : integer := 32);
        port (
            clk             : in std_logic;                   -- Clock input
            rst             : in std_logic;                   -- Reset input
            start           : in std_logic;                   -- Start calculation signal
            A               : in unsigned((2*N) - 1 downto 0);  -- Input data 
            Result          : out unsigned(N - 1 downto 0);     -- Square root output (it is 32 bits fixed point)
            finished        : out std_logic                   -- 1 When calculation is done
        );
    end component;

    constant clk_period : time := 10 ps;    --set the clock period for simulation.
    constant N : integer := 32;    --width of the input.
    signal clk, rst, finished_tb : std_logic := '0';
    signal inp_tb : unsigned((2*N)-1 downto 0) := (others => '0');
    signal result_tb : unsigned(N - 1 downto 0);
    signal start_tb : std_logic;

begin

    clk <= not clk after clk_period / 2;    --generate clock by toggling 'clk'.

    --entity instantiation.
    DUT : entity work.newton_method generic map(N => N)
             port map(clk, rst, start_tb, inp_tb, result_tb, finished_tb);

    SEQUENCER_PROC : process
    begin
        rst <= '1'; start_tb <= '1'; inp_tb <= to_unsigned(0, 64);               --Testing sqrt(0)
        wait for clk_period; rst <= '0';
        wait until finished_tb = '1';

        wait for clk_period; rst <= '1'; inp_tb <= to_unsigned(1, 64);           --Testing sqrt(1)
        wait for clk_period; rst <= '0';      
        wait until finished_tb = '1';

        wait for clk_period; rst <= '1'; inp_tb <= to_unsigned(512, 64);          --Testing sqrt(512)
        wait for clk_period; rst <= '0';      
        wait until finished_tb = '1';

        wait for clk_period; rst <= '1'; inp_tb <= to_unsigned(5499030, 64);      --Testing sqrt(5499030)
        wait for clk_period; rst <= '0';      
        wait until finished_tb = '1';

        wait for clk_period; rst <= '1'; inp_tb <= to_unsigned(1194877489, 64);    --Testing sqrt(1194877489)
        wait for clk_period; rst <= '0';      
        wait until finished_tb = '1';

        report "Simulation finished";
        wait;
    end process;

end architecture;

