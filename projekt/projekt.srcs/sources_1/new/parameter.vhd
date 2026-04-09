----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2026 17:26:19
-- Design Name: 
-- Module Name: parameter - Behavioral
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
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity parameter is
    Port ( 
    rst : in STD_LOGIC;
    clk : in STD_LOGIC;
    left : in STD_LOGIC;
    right : in STD_LOGIC;
    up : in STD_LOGIC;
    down : in STD_LOGIC;
    display : out STD_LOGIC_VECTOR (31 downto 0);
    blink : out STD_LOGIC_VECTOR (7 downto 0);
    freq : out STD_LOGIC_VECTOR (13 downto 0);
    waveform : out STD_LOGIC_VECTOR (1 downto 0)
           );
end parameter;

architecture Behavioral of parameter is
    
    signal sig_selected : integer range 0 to 7 := 7;
    signal freq_raw : STD_LOGIC_VECTOR (13 downto 0);
    
    --array jednotlivých bcd kodů sedmisegmentů
    type t_bcd_array is array (0 to 7) of std_logic_vector(3 downto 0);
    signal bcd_digits : t_bcd_array := (
         2 => x"4", 
         others => x"0");
    
begin
    parameter : process (clk) is
    begin
        if rising_edge(clk) then  -- Synchronous process
            --reset
            if rst = '1' then 
                sig_selected <= 7;
                bcd_digits <= (2 => x"4",others => x"0");
            
            --posun výběru doleva, z 7 segmentu jdeme na 0 (přetečení), z 4 jdeme na 7 (5 a 6 nepoužity, slouží jako odělení dvou informací)
            elsif left = '1' then
                if sig_selected = 7 then
                    sig_selected <= 0;
                elsif sig_selected = 4 then
                    sig_selected <= 7;
                else
                    sig_selected <= sig_selected + 1;
                end if;
            
            --posun výběru doleva, z 0 segmentu jdeme na 7 (podtečení), z 7 jdeme na 4    
            elsif right = '1' then
                if sig_selected = 0 then
                    sig_selected <= 7;
                elsif sig_selected = 7 then
                    sig_selected <= 4;
                else
                    sig_selected <= sig_selected - 1;
                end if;    
            
            --přičtení 1 k vybranému segmentu, zde se řeší pouze aby čísla byly v dec soustavě
            --ošetření rozsahu se řeší dle segmentu dále ale až další cyklus z důvodu jedoduchosti
            elsif up = '1' then
                if bcd_digits(sig_selected) = x"9" then
                    bcd_digits(sig_selected) <= x"0";
                else
                    bcd_digits(sig_selected) <= std_logic_vector(unsigned(bcd_digits(sig_selected)) + 1);
                end if;
                
            --odečtení 1 z vybranémho segmentu,
            elsif down ='1'then 
                if bcd_digits(sig_selected) = x"0" then
                    bcd_digits(sig_selected) <= x"9";
                else
                    bcd_digits(sig_selected) <= std_logic_vector(unsigned(bcd_digits(sig_selected)) - 1);
                end if;
            end if; 
            
            --sečtení jednotlivých segmentů
            freq_raw <= std_logic_vector(
            resize(
                (resize(unsigned(bcd_digits(4)), 14) * 10000) +
                (resize(unsigned(bcd_digits(3)), 14) * 1000) +
                (resize(unsigned(bcd_digits(2)), 14) * 100) +
                (resize(unsigned(bcd_digits(1)), 14) * 10) +
                 resize(unsigned(bcd_digits(0)), 14), 14));
            
            --oštření segmentů aby byly v rozsahu, tento kod proběhne kvuli zpoždění jednoho cyklu až později
            --samotné ošetření výstupů je dále, tohle je jenom aby se segmenty vrátili eventuelně na validní
            --několik cyklů na segmentu nevadí protože je to velmi krátký usek                  
            if unsigned(freq_raw) = 0 then
                freq_raw <= std_logic_vector(to_unsigned(1, 14)); 
                bcd_digits(0) <= x"1";
                
            elsif unsigned(freq_raw) > 10000 or unsigned(bcd_digits(4)) > 1 then 
                freq_raw <= std_logic_vector(to_unsigned(10000, 14)); 
                bcd_digits(0) <= x"0";
                bcd_digits(1) <= x"0";
                bcd_digits(2) <= x"0";
                bcd_digits(3) <= x"0";
                bcd_digits(4) <= x"1";
            end if;
            
            if bcd_digits(7) = x"7" then 
               bcd_digits(7) <= x"3";
            elsif unsigned(freq_raw) > 3 then
               bcd_digits(7) <= x"0";            
            end if;
        end if;
    end process;
   
   
    
    
    --segment 5 a 6 jsou nepoužity, jiné hodnoty než čísla v dec soustavě jsou zhasnuté
    display <= bcd_digits(7) & x"F" & x"F" & bcd_digits(4) & bcd_digits(3) & bcd_digits(2) & bcd_digits(1) & bcd_digits(0);
    
    --jsou to přesně dva bity takže když je vybereme tak i když bude v segmentu 5 tak budeme koukat jenom na ty dva bity
    waveform <= bcd_digits(7)(1 downto 0);
    
    --když uživatel nasataví frekvenci na mimo rozsach tak na jeden cyklus zůstane mimo rozsach
    freq <= std_logic_vector(to_unsigned(1, 14)) when unsigned(freq_raw) = 0 else 
            std_logic_vector(to_unsigned(10000, 14)) when unsigned(freq_raw) > 10000 else freq_raw;
    
    blink <= b"00000001" when sig_selected = 0 else
             b"00000010" when sig_selected = 1 else
             b"00000100" when sig_selected = 2 else
             b"00001000" when sig_selected = 3 else
             b"00010000" when sig_selected = 4 else
             b"00100000" when sig_selected = 5 else
             b"10000000";
    
end Behavioral;
