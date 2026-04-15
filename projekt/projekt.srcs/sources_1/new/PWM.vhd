----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2026 17:58:54
-- Design Name: 
-- Module Name: PWM - Behavioral
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

entity PWM is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           amplitude : in STD_LOGIC_VECTOR (7 downto 0);
           pwm : out STD_LOGIC);
end PWM;
    
architecture Behavioral of PWM is
    signal sig_pwm_counter : unsigned(7 downto 0) := (others => '0');
    signal sig_pwm : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            sig_pwm_counter <= sig_pwm_counter + 1;
            --reset
            if rst = '1' then
                sig_pwm <= '0';
            elsif sig_pwm_counter <= unsigned(amplitude) then
                sig_pwm <= '1';
            else 
                sig_pwm <= '0';
            end if;
        end if;
    end process;
    
    pwm <= sig_pwm;
    
end Behavioral;
