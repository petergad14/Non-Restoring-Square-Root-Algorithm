architecture a4 of square_root is




    type inp_arr is array (N - 1 downto 0) of unsigned((2*N) - 1 downto 0);
    type L_R_temp is array (N - 1 downto 0) of unsigned((N) + 1 downto 0);
    type q_arr is array (N - 1 downto 0) of unsigned(N - 1 downto 0);


    signal inp : inp_arr;  -- take the input in a variable
    signal R : inp_arr; --Remainder
    signal q : q_arr;  --Result variable
    signal nextop : unsigned(N - 1 downto 0); 


    

    
      
    begin
    
        process(clk)      
                      
            variable left, right : L_R_temp;  --Left and right sides of the adder based on the figure.            
            variable temp : L_R_temp; 
            variable i : integer;
            variable k : integer := 0;
            begin
                if rising_edge(clk) then 
                    if rst = '1' then
                        
                        Result <=  (others => 'X');
                        finished <= '0';
                        R <= (others => (others => '0'));
                        left := (others => (others => '0'));
                        right := (others => (others => '0'));
                        q <= (others => (others => '0'));
                        temp := (others => (others => '0'));
                        inp <= (others => (others => '0'));
                        nextop <= (others => '0');
                        i := (2*N);
                    elsif(start = '1') then                
                        -- first stage
                        left(0)(2 downto 0) := '0' & A((2*N) - 1 downto (2*N) - 2);
                        right(0)(2 downto 0) := '0' & '0' & '1';
                        temp(0) := left(0) - right(0);
                        q(0)(0) <= not(temp(0)(2));  
                        nextop(0) <= not(temp(0)(2));                                
                        R(0)((2*N) - 1 downto (2*N) - 2) <= temp(0)(1 downto 0);
                        inp(0) <= shift_left(A, 2);   
                         
                        -- Rest of pipelined stages
                        i := (2*N) - 1;
                        for j in 1 to N-1 loop                                   
                            left(j)((2*N)-i+2 downto 0) := R(j-1)(i downto i-j) & inp(j-1)((2*N)-1 downto (2*N)-2);
                            right(j)(((2*N)-i+2) downto 0) := '0' & q(j-1)(j-1 downto 0) & not(q(j-1)(0)) & '1'; 
                            if(nextOp(j - 1) = '1') then
                                temp(j) := left(j) - right(j);
                            else
                                temp(j) := left(j) + right(j);
                            end if;
                            inp(j) <= shift_left(inp(j - 1), 2);
                            q(j)    <= shift_left(q(j-1), 1);
                            q(j)(0) <= not(temp(j)((2*N)-i+2));
                            R(j)((2*N) - j - 1 downto i - j - 2) <= temp(j)(((2*N)-i+1) downto 0);
                            nextOp(j) <= not temp(j)(j+2);                                    
                            i := i - 1;         
                            
                        end loop;
                        k := k + 1;
                        if(k < N + 1) then
                            Result <= (others => 'X');
                        else
                            Result <= (q(N-1));  
                            finished <= '1' ;
                        end if;       
                    end if;
                end if;
        end process;
        

end architecture;
