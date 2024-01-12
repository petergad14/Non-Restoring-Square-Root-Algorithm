architecture a5 of square_root is

    type state_type is (WAIT_ST, INIT, PREP, INTER, REMAIN, OUTP, DONE);
    signal state : state_type;

    signal inp : unsigned((2*N) - 1 downto 0);  -- take the input in a variable
    signal q : unsigned(N-1 downto 0);  --Result variable
    signal left, right : unsigned(N+1 downto 0);  --Left and right sides of the adder based on the figure.
    signal R : unsigned(N+1 downto 0); --Remainder
    signal i : integer := 0;
    signal shift_1_en : std_logic := '0';
    signal shift_2_en : std_logic := '0';
    signal inp_shifted : unsigned((2*N) - 1 downto 0);
    signal q_shifted : unsigned(N-1 downto 0);
    signal adder_en: std_logic := '0';
    signal diff : unsigned(N+1 downto 0);
    

    component inp_BarrelShifter is --input Barrel Shifter
        generic(
            N       :       integer := 64
          );
          port(
            A       :in      unsigned(N-1 downto 0);
            shift   : in std_logic;
            Y       :out     unsigned(N-1 downto 0)
          );
    end component;       
    
    component out_BarrelShifter is --Q Barrel Shifter
        generic(
            N       :       integer := 32
        );
        port(
            A       :in      unsigned(N-1 downto 0);
            inpu    :in      std_logic;
            shift   :in      std_logic;
            Y       :out     unsigned(N-1 downto 0)
        );
    end component;

    component add_sub is --Adder/Subtractor entity
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
    end component; 
      
    begin
        s1: entity work.inp_BarrelShifter port map(inp, shift_1_en, inp_shifted);
        s2: entity work.out_BarrelShifter port map(q, R(N+1), shift_2_en, q_shifted);
        add_sub_1: entity work.add_sub port map(left, right, R(N+1), adder_en, diff);
    
        process(clk)
            begin
                if rising_edge(clk) then 
                    if rst = '1' then
                        state <= WAIT_ST;
                        Result <= (others => '-');
                        inp <= (others => '-');
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
                            when INIT => --Initialize state
                                inp <= A;
                                i <= 0;
                                state <= PREP;                                
                            when PREP => --Prepare state
                                shift_1_en <= '1';
                                right <= q & R(N+1) & '1';  --right side logic
                                left <= R(N-1 downto 0) & inp((2 * N)-1 downto (2*N) - 2); --left side logic
                                state <= INTER;
                            when INTER => --Intermediate state
                                inp <= inp_shifted;
                                adder_en <= '1';
                                state <= REMAIN;
                            when REMAIN => --Remainder state
                                shift_1_en <= '0';
                                shift_2_en <= '1';
                                if(adder_en = '1') then
                                    R <= diff;
                                else
                                    R <= R;
                                end if;
                                adder_en <= '0';
                                state <= OUTP;
                            when OUTP => --Output state
                                shift_2_en <= '0';
                                i <= i + 1;
                                if(i<N-1) then
                                    state <= PREP;
                                else
                                    state <= DONE;
                                end if;
                                q <= q_shifted;
                            when DONE => --Done state
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