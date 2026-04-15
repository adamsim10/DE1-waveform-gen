----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2026 19:00:29
-- Design Name: 
-- Module Name: TRI_W - Behavioral
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

entity TRI_W is
    Port ( phase : in STD_LOGIC_VECTOR (7 downto 0);
           amplitude : out STD_LOGIC_VECTOR (7 downto 0));
end TRI_W;

architecture Behavioral of TRI_W is
    
begin
    amplitude <= phase;
end Behavioral;
