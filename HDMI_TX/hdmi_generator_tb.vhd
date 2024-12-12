library ieee;
use ieee.std_logic_1164.all;

entity hdmi_generator_tb is
end entity hdmi_generator_tb;

architecture tb of hdmi_generator_tb is
		constant h_res 	: natural := 32; --Résolution  horizontale en pixel
		constant v_res 	: natural := 24; --Résolution verticale en pixel
		
		signal i_clk  		:  std_logic;
    	signal i_reset_n 	:  std_logic;
		
    	signal o_hdmi_hs   :  std_logic;
    	signal o_hdmi_vs   :  std_logic;
    	signal o_hdmi_de   :  std_logic;

		signal o_pixel_en :  std_logic;-- indique pixel valide
		signal o_pixel_address :  natural range 0 to (h_res * v_res - 1); 
		signal o_x_counter :  natural range 0 to (h_res - 1);
		signal o_y_counter :  natural range 0 to (v_res - 1);
		signal o_new_frame :  std_logic;
		
		signal finished :  boolean := false;

begin
	uut : entity work.hdmi_generator
	generic map (
		h_res => h_res,
		v_res => v_res
	)
	port map (
		i_clk => i_clk,
		i_reset_n => i_reset_n,
		o_hdmi_hs => o_hdmi_hs,
		o_hdmi_vs => o_hdmi_vs,
		o_hdmi_de => o_hdmi_de,
		
		o_pixel_en => o_pixel_en,
		o_pixel_address => o_pixel_address,
		o_x_counter => o_x_counter,
		o_y_counter => o_y_counter,
		o_new_frame => o_new_frame
	);

	process
	begin
		while(finished = false) loop
			i_clk <= '0'; wait for 5 ns;
			i_clk <= '1'; wait for 5 ns;
		end loop;
		wait;
	end process;
	
	process
	begin
	i_reset_n <= '0';
	wait for 150 ns;
	i_reset_n <= '1';
	wait for 150 ns;
	finished <= true;
	
	end process;
	-- 2eme process pour générer les stimuli
	-- il ne faut pas oublier le finished
end architecture tb;