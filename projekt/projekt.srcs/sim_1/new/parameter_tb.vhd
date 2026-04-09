-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 09 Apr 2026 18:29:56 GMT
-- Request id : cfwk-fed377c2-69d7f02415e27

library ieee;
use ieee.std_logic_1164.all;

entity tb_parameter is
end tb_parameter;

architecture tb of tb_parameter is

    component parameter
        port (rst      : in std_logic;
              clk      : in std_logic;
              left     : in std_logic;
              right    : in std_logic;
              up       : in std_logic;
              down     : in std_logic;
              display  : out std_logic_vector (31 downto 0);
              blink    : out std_logic_vector (7 downto 0);
              freq     : out std_logic_vector (13 downto 0);
              waveform : out std_logic_vector (1 downto 0));
    end component;

    signal rst      : std_logic;
    signal clk      : std_logic;
    signal left     : std_logic;
    signal right    : std_logic;
    signal up       : std_logic;
    signal down     : std_logic;
    signal display  : std_logic_vector (31 downto 0);
    signal blink    : std_logic_vector (7 downto 0);
    signal freq     : std_logic_vector (13 downto 0);
    signal waveform : std_logic_vector (1 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : parameter
    port map (rst      => rst,
              clk      => clk,
              left     => left,
              right    => right,
              up       => up,
              down     => down,
              display  => display,
              blink    => blink,
              freq     => freq,
              waveform => waveform);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- Inicializace na nuly
        rst <= '0';
        left <= '0';
        right <= '0';
        up <= '0';
        down <= '0';

        rst <= '1';
        wait for 2 * TbPeriod;
        rst <= '0';
        wait for 2 * TbPeriod;
        
        
        --přetečení výběru průběhu
        for i in 1 to 4 loop
            up <= '1';
            wait for TbPeriod;
            up <= '0';
            wait for 2 * TbPeriod;
        end loop;
        
        --druhý směr
        for i in 1 to 4 loop
            down <= '1';
            wait for TbPeriod;
            down <= '0';
            wait for 2 * TbPeriod;
        end loop;
        
        --posun doprava celý ciklus
        for i in 1 to 8 loop
            right <= '1';
            wait for TbPeriod;
            right <= '0';
            wait for 2 * TbPeriod;
        end loop;
        
        --druhý směr + najede až na desítky
        for i in 1 to 10 loop
            left <= '1';
            wait for TbPeriod;
            left <= '0';
            wait for 2 * TbPeriod;
        end loop;
        
        --projedeme desítky
        for i in 1 to 11 loop
            up <= '1';
            wait for TbPeriod;
            up <= '0';
            wait for 2 * TbPeriod;
        end loop;
        
        --druhý směr
        for i in 1 to 11 loop
            down <= '1';
            wait for TbPeriod;
            down <= '0';
            wait for 2 * TbPeriod;
        end loop;
        
        --posun na stovky skusíme f=0
        left <= '1';
        wait for TbPeriod;
        left <= '0';
        wait for 2 * TbPeriod;
        
        for i in 1 to 4 loop
            down <= '1';
            wait for TbPeriod;
            down <= '0';
            wait for 2 * TbPeriod;
        end loop;
        
        --skusíme větší ne 10 000 
        for i in 1 to 2 loop
            left <= '1';
            wait for TbPeriod;
            left <= '0';
            wait for 2 * TbPeriod;
        end loop;
        
        for i in 1 to 2 loop
            up <= '1';
            wait for TbPeriod;
            up <= '0';
            wait for 2 * TbPeriod;
        end loop;
        
        --skusíme i druhý směr
        for i in 1 to 2 loop
            down <= '1';
            wait for TbPeriod;
            down <= '0';
            wait for 2 * TbPeriod;
        end loop;
        
        -- Menší pauza před koncem simulace
        wait for 10 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_parameter of tb_parameter is
    for tb
    end for;
end cfg_tb_parameter;