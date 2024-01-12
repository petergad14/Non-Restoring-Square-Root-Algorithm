library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_pkg.all;

entity newton_method is

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
end newton_method;

architecture behavioral of newton_method is 
begin
    process(clk, rst)
    variable i : unsigned(N - 1 downto 0) := to_unsigned(0, 32); --index of the loop.
    variable qi : ufixed(63 downto -32);  -- X_n
    variable qf : ufixed(63 downto -32);  -- X_n+1
    variable inp : ufixed(63 downto -32); -- variable to hold the input
    variable start_temp : std_logic;

    begin

        if(rst = '1') then 
            finished <= '0';
            Result <= (others => '-');
            inp := to_ufixed(A,inp);
            qf := resize(inp * 0.5, 63, -32); --inital value
            start_temp := start;
            
        elsif(rising_edge(clk) and start_temp = '1') then
            start_temp := start;
            if(i = 0) then  
            finished <= '0';    --reset 'done' signal.
            i := i+1;   --increment the loop index.

            elsif(i < N) then --keep incrementing the loop index.
                if(inp = 0) then --if input is 0, exit the loop and Result = 0
                    i := to_unsigned(32,32);
                else
                    qi := qf; --X_n = X_n+1
                    qf := resize(((inp/qf + qf) * 0.5),63,-32); --Newton equation
                    
                    if(qf = qi) then
                        i := to_unsigned(32,32); --Exit the loop when two consecutive iterations give the same result
                    else
                        i := i+1; 
                    end if;
                end if;
            else
                finished <= '1'; --Raise the finished flag
                Result <= unsigned(qf(N-1 downto 0)); --Put the final value in the results
                i := to_unsigned(0,32);
                start_temp := '0';
            end if;
        end if;

    end process;
      
end architecture;