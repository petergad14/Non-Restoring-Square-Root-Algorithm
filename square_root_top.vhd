library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is

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
end top;

architecture structural of top is


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


    component fsm is
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
    end component;

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


    begin
        s1: entity work.inp_BarrelShifter port map(inp, shift_1_en, inp_shifted);
        s2: entity work.out_BarrelShifter port map(q, R(N+1), shift_2_en, q_shifted);
        add_sub_1: entity work.add_sub port map(left, right, R(N+1), adder_en, diff);
        fsm1: entity work.square_root(a5) port map(clk, rst, start, A, Result, finished);


end structural;

