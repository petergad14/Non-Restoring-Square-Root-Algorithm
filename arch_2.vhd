library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity arch_2 is

    generic (
        N : integer := 32  -- Number of bits for output
        );
    
    port (
        clk             : in std_logic;                   -- Clock input
        rst             : in std_logic;                   -- Reset input
        start           : in std_logic;                   -- Start calculation signal
        A               : in unsigned((2*N) - 1 downto 0);  -- Input data 
        Result          : out unsigned(N - 1 downto 0);     -- Square root output (it is 32 bits fixed point)
        finished        : out std_logic                   -- 1 When calculation is done
        );
end arch_2;

architecture behavioral of arch_2 is 

type state_type is (WAIT_ST, INIT, COMP, DONE);
signal state : state_type;



begin
    process (clk)
    variable i : integer;
    variable Z : unsigned((2*N) - 1 downto 0);
    variable R : signed((2*N) - 1 downto 0);
    variable D : unsigned((2*N) - 1 downto 0);
    variable P : std_logic_vector((2*N) - 1 downto 0);
    variable X : std_logic_vector((2*N) - 1 downto 0);
    variable one : std_logic_vector((2*N) - 1 downto 0) := (0 => '1', others => '0');
    variable three : std_logic_vector((2*N) - 1 downto 0) := (0 => '1', 1 => '1', others => '0');
    variable zero : std_logic_vector((2*N) - 3 downto 0) := (others => '0');

    begin
        if rising_edge(clk) then 
            if rst = '1' then
                state <= WAIT_ST;
                Result <= (others => '-');
                finished <= '0';
                R := (others => '0');
                Z := (others => '0');
                P := (others => '0');
                i := 0;
            else 
                case state is

                    when WAIT_ST =>
                        D := A;
                        if(start = '1') then
                            state <= INIT;
                        else 
                            state <= WAIT_ST;
                        end if;
                    
                    when INIT =>
                        i := N;
                        state <= COMP;
                    when COMP => 
                            if(i > 0) then
                                state <= COMP;
                                if(R(2*N - 1) = '0') then
                                    P := std_logic_vector((D srl (i+i-2)));               -- D >> (i+i)
                                    P := zero & P(1 downto 0);                      -- D >> (i+i) & 3
                                    P := std_logic_vector(R sll 2) or P;      -- (R << 2) | D >> (i+i) & 3
                                    X := (std_logic_vector(Z sll 2)) or one;
                                    R := signed(P) - signed(X);                                   
                                    report "R biger than or equal 0";
                                else
                                    P := std_logic_vector((D srl (i+i-2)));               -- D >> (i+i)
                                    P := zero & P(1 downto 0);                      -- D >> (i+i) & 3
                                    P := std_logic_vector(R sll 2) or P;      -- (R << 2) | D >> (i+i) & 3
                                    X := (std_logic_vector(Z sll 2)) or three;
                                    R := signed(P) + signed(X);
                                    report "R smaller than 0";
                                end if;
                                if(R(2*N - 1) = '0') then
                                    Z := unsigned((std_logic_vector(Z sll 1)) or one);
                                else
                                Z := (Z sll 1);
                                end if;
                                i := i - 1;
                            else
                                if(R(2*N - 1) = '1') then
                                    R := R + signed((std_logic_vector(Z sll 1)) or one);
                                else
                                    R := R;
                                end if;
                                state <= DONE;
                            end if;
                    when DONE => 
                        finished <= '1';
                        Result <= Z(N-1 downto 0);
                        if(start = '1') then
                            state <= DONE;
                        else
                            state <= WAIT_ST;
                        end if;

                end case;          
            end if;
        end if;
    end process;

end architecture;

