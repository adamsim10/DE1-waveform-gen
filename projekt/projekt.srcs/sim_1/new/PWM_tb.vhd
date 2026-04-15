-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 15 Apr 2026 16:17:41 GMT
-- Request id : cfwk-fed377c2-69dfba2552ba0

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity PWM_tb is
end PWM_tb;

architecture tb of PWM_tb is

    component PWM
        port (clk       : in std_logic;
              rst       : in std_logic;
              amplitude : in std_logic_vector (7 downto 0);
              pwm       : out std_logic);
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal amplitude : std_logic_vector (7 downto 0);
    signal pwm_s       : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : PWM
    port map (clk       => clk,
              rst       => rst,
              amplitude => amplitude,
              pwm       => pwm_s);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        amplitude <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 1000 * TbPeriod;
        
        amplitude <= std_logic_vector(to_unsigned(0,8));
        
         wait for 1000 * TbPeriod;
         
         amplitude <= std_logic_vector(to_unsigned(16,8));
         
         wait for 1000 * TbPeriod;
         
         amplitude <= std_logic_vector(to_unsigned(128,8));
         
         wait for 1000 * TbPeriod;
         
         amplitude <= std_logic_vector(to_unsigned(255,8));
         
         wait for 1000 * TbPeriod;
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_PWM of PWM_tb is
    for tb
    end for;
end cfg_tb_PWM;