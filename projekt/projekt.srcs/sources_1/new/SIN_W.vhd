library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Nutné pro převod vektoru na integer (indexování pole)

entity SIN_W is
    Port ( 
        phase     : in  STD_LOGIC_VECTOR (7 downto 0);
        amplitude : out STD_LOGIC_VECTOR (7 downto 0)
    );
end SIN_W;

architecture Behavioral of SIN_W is
    -- Definice typu pro Look-Up Tabulku (256 hodnot)
    type rom_type is array (0 to 255) of std_logic_vector(7 downto 0);
    
    -- Inicializace tabulky hodnotami funkce sinus (posunuto do kladných čísel)
    -- Hodnoty odpovídají: 127 + 127 * sin(2 * pi * i / 256)
    constant SIN_ROM : rom_type := (
        x"7f", x"82", x"85", x"88", x"8b", x"8e", x"91", x"94", x"97", x"9a", x"9d", x"a0", x"a3", x"a6", x"a9", x"ac",
        x"af", x"b2", x"b5", x"b8", x"bb", x"bd", x"c0", x"c3", x"c5", x"c8", x"ca", x"cd", x"cf", x"d1", x"d4", x"d6",
        x"d8", x"da", x"dc", x"de", x"e0", x"e2", x"e4", x"e5", x"e7", x"e9", x"ea", x"eb", x"ed", x"ee", x"ef", x"f0",
        x"f2", x"f3", x"f4", x"f4", x"f5", x"f6", x"f7", x"f7", x"f8", x"f9", x"f9", x"f9", x"fa", x"fa", x"fa", x"fa",
        x"fa", x"fa", x"fa", x"fa", x"fa", x"f9", x"f9", x"f9", x"f8", x"f7", x"f7", x"f6", x"f5", x"f4", x"f4", x"f3",
        x"f2", x"f0", x"ef", x"ee", x"ed", x"eb", x"ea", x"e9", x"e7", x"e5", x"e4", x"e2", x"e0", x"de", x"dc", x"da",
        x"d8", x"d6", x"d4", x"d1", x"cf", x"cd", x"ca", x"c8", x"c5", x"c3", x"c0", x"bd", x"bb", x"b8", x"b5", x"b2",
        x"af", x"ac", x"a9", x"a6", x"a3", x"a0", x"9d", x"9a", x"97", x"94", x"91", x"8e", x"8b", x"88", x"85", x"82",
        x"7f", x"7c", x"79", x"76", x"73", x"70", x"6d", x"6a", x"67", x"64", x"61", x"5e", x"5b", x"58", x"55", x"52",
        x"4f", x"4c", x"49", x"46", x"43", x"41", x"3e", x"3b", x"39", x"36", x"34", x"31", x"2f", x"2d", x"2a", x"28",
        x"26", x"24", x"22", x"20", x"1e", x"1c", x"1a", x"19", x"17", x"15", x"14", x"13", x"11", x"10", x"0f", x"0e",
        x"0c", x"0b", x"0a", x"0a", x"09", x"08", x"07", x"07", x"06", x"05", x"05", x"05", x"04", x"04", x"04", x"04",
        x"04", x"04", x"04", x"04", x"04", x"05", x"05", x"05", x"06", x"07", x"07", x"08", x"09", x"0a", x"0a", x"0b",
        x"0c", x"0e", x"0f", x"10", x"11", x"13", x"14", x"15", x"17", x"19", x"1a", x"1c", x"1e", x"20", x"22", x"24",
        x"26", x"28", x"2a", x"2d", x"2f", x"31", x"34", x"36", x"39", x"3b", x"3e", x"41", x"43", x"46", x"49", x"4c",
        x"4f", x"52", x"55", x"58", x"5b", x"5e", x"61", x"64", x"67", x"6a", x"6d", x"70", x"73", x"76", x"79", x"7c"
    );

begin
    -- Výstupem je hodnota z ROM na indexu daném vstupní fází
    amplitude <= SIN_ROM(to_integer(unsigned(phase)));

end Behavioral;