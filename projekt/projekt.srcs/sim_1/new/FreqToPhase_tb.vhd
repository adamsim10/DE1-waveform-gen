-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 15 Apr 2026 15:36:50 GMT
-- Request id : cfwk-fed377c2-69dfb09209153

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity tb_FreqToPhase is
end tb_FreqToPhase;

architecture tb of tb_FreqToPhase is

    component FreqToPhase
        port (clk       : in std_logic;
              rst       : in std_logic;
              freq_in   : in std_logic_vector (13 downto 0);
              phase_out : out std_logic_vector (7 downto 0));
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal freq_in   : std_logic_vector (13 downto 0);
    signal phase_out : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : FreqToPhase
    port map (clk       => clk,
              rst       => rst,
              freq_in   => freq_in,
              phase_out => phase_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        rst <= '0';
        freq_in <= (others => '0');

        -- ***EDIT*** Add stimuli here
        wait for 5 * TbPeriod;
        
        --reset desky
        rst <='1';
        wait for 2 * TbPeriod;
        rst <='0';
        wait for 2 * TbPeriod;

        freq_in <= std_logic_vector(to_unsigned(1000, 14));
        
        wait for 10000 * TbPeriod;
        
        freq_in <= std_logic_vector(to_unsigned(400, 14));
        
        wait for 10000 * TbPeriod;
        
        freq_in <= std_logic_vector(to_unsigned(10000, 14));
        
        wait for 10000 * TbPeriod;
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_FreqToPhase of tb_FreqToPhase is
    for tb
    end for;
end cfg_tb_FreqToPhase;