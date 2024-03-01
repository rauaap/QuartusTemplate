Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity quartusTemplate is 
    port(
        switch: in std_logic;
        led: out std_logic
    );
end entity quartusTemplate;


architecture rtl of quartusTemplate is
begin
    led <= switch;
end architecture rtl;
