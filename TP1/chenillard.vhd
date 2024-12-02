library ieee;
use ieee.std_logic_1164.all;

entity chenillard is
	port (
		i_clk : in std_logic;
		i_rst_n : in std_logic;
		o_led : out std_logic_vector(7 downto 0)
	);
end entity chenillard;

architecture rtl of chenillard is
	signal r_led_vector : std_logic_vector(7 downto 0) := "00000001";
begin
	process(i_clk, i_rst_n)
	variable counter : natural range 0 to 5000000 := 0;
	begin
		if (i_rst_n = '0') then
			counter := 0;
			r_led_vector <= "00000001";
		elsif (rising_edge(i_clk)) then
			if (counter = 5000000) then
				counter := 0;
				r_led_vector(6 downto 0) <= r_led_vector(7 downto 1);
				r_led_vector(7) <= r_led_vector(0);
			else
				counter := counter + 1;
			end if;
		end if;
	end process;
	
	o_led <= r_led_vector;
end architecture rtl;

