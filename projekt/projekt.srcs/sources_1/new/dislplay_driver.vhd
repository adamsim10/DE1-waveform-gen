-----------------------------------------------------------
--! @brief Display driver top-level
--! @version 1.2
--! @copyright (c) 2020-2026 Tomas Fryza, MIT license
--!
--! Drives a 2-digit 7-segment display using multiplexing.
--! Input data is split into high and low nibbles for each digit.
--
-- Notes:
-- - Supports 2-digit display
-- - Uses clock enable and counter for digit multiplexing
-- - Anode logic is active-low for common-anode displays
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_driver is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        data  : in  std_logic_vector(31 downto 0);  -- Vector of input bits, 4 per digit
        seg   : out std_logic_vector(6 downto 0);
        anode : out std_logic_vector(7 downto 0)
    );
end entity display_driver;

architecture Behavioral of display_driver is

        -- Component declaration for clock enable
        component clk_en is
            generic ( G_MAX : positive );
            port (
                clk : in  std_logic;
                rst : in  std_logic;
                ce  : out std_logic
            );
        end component clk_en;
    
        -- Component declaration for binary counter
        component counter is
            generic ( G_BITS : positive );
            port (
                clk : in  std_logic;
                rst : in  std_logic;
                en  : in  std_logic;
                cnt : out std_logic_vector(G_BITS - 1 downto 0)
            );
        end component counter;
    
        -- Component declaration for bin2seg
        component bin2seg is
            port (
                bin : in  std_logic_vector(3 downto 0);
                seg : out std_logic_vector(6 downto 0)
            );
        end component bin2seg;
    
    -- Internal signals
    signal sig_en    : std_logic;
    signal sig_digit : std_logic_vector(2 downto 0);  -- Can be scalable
    signal sig_bin   : std_logic_vector(3 downto 0);

begin

    ------------------------------------------------------------------------
    -- Clock enable generator for refresh timing
    ------------------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => 800_000 ) -- Adjust for flicker-free multiplexing
        port map (                 -- For simulation: 1
            clk => clk,            -- For implementation: 8_000_000
            rst => rst,
            ce  => sig_en
        );

    ------------------------------------------------------------------------
    -- N-bit counter for digit selection
    ------------------------------------------------------------------------
    counter_0 : counter
       generic map ( G_BITS => 3 )
       port map (
           clk => clk,
           rst => rst,
           en  => sig_en,
           cnt => sig_digit
       );


    ------------------------------------------------------------------------
    -- Digit select
    ------------------------------------------------------------------------
    sig_bin <=  data(3 downto 0)   when sig_digit = "000" else
                data(7 downto 4)   when sig_digit = "001" else
                data(11 downto 8)  when sig_digit = "010" else
                data(15 downto 12) when sig_digit = "011" else
                data(19 downto 16) when sig_digit = "100" else
                data(23 downto 20) when sig_digit = "101" else
                data(27 downto 24) when sig_digit = "110" else
                data(31 downto 28);

    anode <=    b"11111110" when sig_digit = "000" else
                b"11111101" when sig_digit = "001" else
                b"11111011" when sig_digit = "010" else
                b"11110111" when sig_digit = "011" else
                b"11101111" when sig_digit = "100" else
                b"11011111" when sig_digit = "101" else
                b"10111111" when sig_digit = "110" else
                b"01111111";
                
    
    ------------------------------------------------------------------------
    -- 7-segment decoder
    ------------------------------------------------------------------------
    decoder_0 : bin2seg
        port map (
            bin => sig_bin,
            seg => seg
        );

end Behavioral;
