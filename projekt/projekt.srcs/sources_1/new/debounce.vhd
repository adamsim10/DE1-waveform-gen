-------------------------------------------------
--! @brief Button debouncer
--! @version 1.1
--! @copyright (c) 2023-2026 Tomas Fryza, MIT license
--!
--! This design implements a debouncer for mechanical
--! push-buttons using a sampling technique with a
--! shift register. The circuit provides a stable 
--! debounced output and generates a one-clock-cycle
--! pulse when a button press is detected.
--
-- Notes:
-- - Synchronous design (rising edge of clk)
-- - High-active synchronous reset
-- - Input synchronization using two flip-flops
-- - Debouncing via shift register and sampling
-- - Configurable debounce time via clock enable
-- - One-clock pulse output for button press
-------------------------------------------------
-- Modified by Simon Tokarcik for continuous pulses when held
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity debounce is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        btn_in      : in  std_logic;  -- Bouncey button input
        btn_state   : out std_logic;  -- Debounced level
        btn_press   : out std_logic;  -- 1-clock press pulse
        -- btn_release : out std_logic   -- 1-clock release pulse
        btn_hold    : out std_logic   -- 1-clock pulse on press + every 0.5s
    );
end entity debounce;

architecture Behavioral of debounce is

    ----------------------------------------------------------------
    -- Constants
    ----------------------------------------------------------------
    constant C_SHIFT_LEN : positive := 4;  -- Debounce history
    constant C_MAX       : positive := 2;  -- Sampling period
                                           -- 2 for simulation
                                           -- 200_000 (2 ms) for implementation !!!
    constant C_PULSE      : positive := 5; -- Pulse delay period
                                           -- 5 for simulation
                                           -- 50_000_000 (0.5 s) for implementation
    
    ----------------------------------------------------------------
    -- Internal signals
    ----------------------------------------------------------------
    signal ce_sample : std_logic;
    signal sync0     : std_logic;
    signal sync1     : std_logic;
    signal shift_reg : std_logic_vector(C_SHIFT_LEN-1 downto 0);
    signal debounced : std_logic;
    signal delayed   : std_logic;
    
    -- Signals for the repeated pulse feature
    signal sig_press   : std_logic;
    signal timer_rst   : std_logic;
    signal ce_half_sec : std_logic;

    ----------------------------------------------------------------
    -- Component declaration for clock enable
    ----------------------------------------------------------------
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
    
begin

    ----------------------------------------------------------------
    -- Clock enable instance (your module)
    ----------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => C_MAX )
        port map (
            clk => clk,
            rst => rst,
            ce  => ce_sample
        );

    ----------------------------------------------------------------
    -- Clock enable instance for repeated pulses
    ----------------------------------------------------------------
    -- Reset timer when main reset is high OR button is NOT pressed
    timer_rst <= rst or not debounced;

    clock_repeat : clk_en
        generic map ( G_MAX => C_PULSE )
        port map (
            clk => clk,
            rst => timer_rst,
            ce  => ce_half_sec
        );
        
    ----------------------------------------------------------------
    -- Synchronizer + debounce
    ----------------------------------------------------------------
    p_debounce : process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                sync0     <= '0';
                sync1     <= '0';
                shift_reg <= (others => '0');
                debounced <= '0';
                delayed   <= '0';

            else
                -- Input synchronizer
                sync1 <= sync0;
                sync0 <= btn_in;

                -- Sample only when enable pulse occurs
                if ce_sample = '1' then

                    -- Shift values to the left and load a new sample as LSB
                    shift_reg <= shift_reg(C_SHIFT_LEN-2 downto 0) & sync1;

                    -- Check if all bits are '1'
                    if shift_reg = (shift_reg'range => '1') then
                        debounced <= '1';
                    -- Check if all bits are '0'
                    elsif shift_reg = (shift_reg'range => '0') then
                        debounced <= '0';
                    end if;

                end if;

                -- One clock delayed output
                delayed <= debounced;
            end if;

        end if;
    end process;

    ----------------------------------------------------------------
    -- Outputs
    ----------------------------------------------------------------
    btn_state <= debounced;

    -- One-clock pulse when button pressed and released
    btn_press   <= debounced and not(delayed);
    -- btn_release <= not(debounced) and delayed;
    
    -- Internal signal for press pulse
    sig_press <= debounced and not(delayed);
    -- Hold: Combines press pulse and periodic pulses
    btn_hold <= sig_press or ce_half_sec;

end architecture Behavioral;