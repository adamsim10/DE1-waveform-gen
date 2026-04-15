-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 15 Apr 2026 17:27:29 GMT
-- Request id : cfwk-fed377c2-69dfca8186c96

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_SAW_W is
end tb_SAW_W;

architecture tb of tb_SAW_W is

    component SAW_W
        port (phase     : in std_logic_vector (7 downto 0);
              amplitude : out std_logic_vector (7 downto 0));
    end component;

    signal phase     : std_logic_vector (7 downto 0);
    signal amplitude : std_logic_vector (7 downto 0);

begin

    dut : SAW_W
    port map (phase     => phase,
              amplitude => amplitude);

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        phase <= (others => '0');

        for i in 0 to 255 loop
            phase <= std_logic_vector(to_unsigned(to_integer(unsigned( phase )) + 1, 8));
            wait for 10ns;
        end loop;

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_SAW_W of tb_SAW_W is
    for tb
    end for;
end cfg_tb_SAW_W;