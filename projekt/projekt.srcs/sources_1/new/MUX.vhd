----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2026 18:49:24
-- Design Name: 
-- Module Name: MUX - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX is
    Port ( SEL : in STD_LOGIC_VECTOR (1 downto 0);
           IN1 : in STD_LOGIC_VECTOR (7 downto 0);
           IN2 : in STD_LOGIC_VECTOR (7 downto 0);
           IN3 : in STD_LOGIC_VECTOR (7 downto 0);
           IN4 : in STD_LOGIC_VECTOR (7 downto 0);
           OUT1 : out STD_LOGIC_VECTOR (7 downto 0));
end MUX;

architecture Behavioral of MUX is

begin
    OUT1 <= IN1 when SEL = "00" else
            IN1 when SEL = "01" else
            IN1 when SEL = "10" else
            IN4;
end Behavioral;
