architecture a3 of square_root_comb is 

function  sqrt_comb  ( A : UNSIGNED ) return UNSIGNED is
    variable inp : unsigned((2*N) - 1 downto 0) := A;  -- take the input in a variable
    variable q : unsigned(N-1 downto 0) := (others => '0');  --Result variable
    variable left, right : unsigned(N+1 downto 0) := (others => '0');  --Left and right sides of the adder based on the figure.
    variable R : unsigned(N+1 downto 0) := (others => '0'); --Remainder
    variable i : integer := 0;
    
    begin
    for i in 0 to N-1 loop
        left := R(N-1 downto 0) & inp(2*N - 1) & inp(2*N - 2); --left side logic
        right := q(N-1 downto 0) & R(N+1) & '1';               --right side logic
        inp(2*N - 1 downto 2) := inp (2*N - 3 downto 0);  --shifed left by 2 bit every iteration.
        if ( R(N+1) = '1') then
        R := left + right; --Remainder
        else
        R := left - right; --Remainder
        end if;
        q := q(N-2 downto 0) & not R(N+1); --shifted left by 1 bit every iteration
    end loop;

    return q;
end sqrt_comb;

begin
    Result <= sqrt_comb ( A );
end architecture;