architecture a4 of square_root is

    type state_type is (WAIT_ST, INIT, PREP, REMAIN, OUTP, DONE);
    signal state : state_type;

    signal inp : unsigned((2*N) - 1 downto 0);  -- take the input in a variable
    signal q : unsigned(N-1 downto 0);  --Result variable
    signal left, right : unsigned(N+1 downto 0);  --Left and right sides of the adder based on the figure.
    signal R : unsigned(N+1 downto 0); --Remainder
    signal i : integer := 0;
      
    begin
    
        process(clk)
            begin
                if rising_edge(clk) then 
                    if rst = '1' then
                        state <= WAIT_ST;
                        Result <= (others => '-');
                        finished <= '0';
                        R <= (others => '0');
                        left <= (others => '0');
                        right <= (others => '0');
                        q <= (others => '0');
                        i <= 0;
                    else 
                        case state is
                            when WAIT_ST =>
                                if(start = '1') then
                                    state <= INIT;
                                else 
                                    state <= WAIT_ST;
                                end if;
                            when INIT =>
                                inp <= A;
                                i <= 0;
                                state <= PREP;
                            when PREP =>   
                                right <= q & R(N+1) & '1';  --right side logic
                                left <= R(N-1 downto 0) & inp((2 * N)-1 downto (2*N) - 2); --left side logic
                                inp <= inp((2*N) - 3 downto 0) & "00"; --shifed left by 2 bit every iteration
                                state <= REMAIN;
                            when REMAIN =>
                                if ( R(N+1) = '1') then   --add or subtract
                                    R <= left + right;     --Remainder
                                else
                                    R <= left - right;      --Remainder
                                end if;
                                state <= OUTP;
                            when OUTP =>
                                q <= q(N-2 downto 0) & not R(N+1);  --shifted left by 1 bit every iteration                          
                                i <= i + 1;
                                if(i<N-1) then
                                    state <= PREP;
                                else
                                    state <= DONE;
                                end if;
                            when DONE => 
                                finished <= '1';
                                Result <= q;
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