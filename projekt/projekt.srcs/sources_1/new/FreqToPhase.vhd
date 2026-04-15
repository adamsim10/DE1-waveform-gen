----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2026 17:22:41
-- Design Name: 
-- Module Name: FreqToPhase - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FreqToPhase is
    Port (
        clk      : in  STD_LOGIC; -- 100 MHz
        rst    : in  STD_LOGIC;
        freq_in  : in  STD_LOGIC_VECTOR(13 downto 0); -- 1 až 10 000
        phase_out: out STD_LOGIC_VECTOR(7 downto 0)   -- Do LUT
    );
end FreqToPhase;

architecture Behavioral of FreqToPhase is
    signal accumulator : unsigned(31 downto 0) := (others => '0');
    signal phase_inc   : unsigned(31 downto 0);
begin
    
    -- phase_inc = freq_in * 43 (protože 2^32 (velikost registru)/ 100e6 (frekvence desky) je 42.94)
    phase_inc <= resize(unsigned(freq_in) * 43, 32);

    process(clk)
    begin
        if rising_edge(clk) then
            --reset
            if rst = '1' then
                accumulator <= (others => '0');
            else
            --přiřtení inkrementu do registru
                accumulator <= accumulator + phase_inc;
            end if;
        end if;
    end process;

    -- Horních 8 bitů akumulátoru
    phase_out <= std_logic_vector(accumulator(31 downto 24));

end Behavioral;
