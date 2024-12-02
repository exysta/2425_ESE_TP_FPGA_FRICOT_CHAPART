library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hdmi_generator is
	generic (
		-- Resolution
		h_res 	: natural := 720; --Résolution  horizontale en pixel
		v_res 	: natural := 480; --Résolution verticale en pixel

		-- Timings magic values (480p)
		h_sync	: natural := 61; -- Sync pulse (lines)
		h_fp	: natural := 58; -- Front porch (px) 
		h_bp	: natural := 18; -- Back porch (px)

		v_sync	: natural := 5; -- Sync pulse (lines)
		v_fp	: natural := 30; -- Front porch (px) 
		v_bp	: natural := 9 -- Back porch (px)
	);
	port (
		i_clk  		: in std_logic;
    	i_reset_n 	: in std_logic;
		
    	o_hdmi_hs   : out std_logic;
    	o_hdmi_vs   : out std_logic;
    	o_hdmi_de   : out std_logic;

		o_pixel_en : out std_logic;-- indique pixel valide
		o_pixel_address : out natural range 0 to (h_res * v_res - 1); 
		o_x_counter : out natural range 0 to (h_res - 1);
		o_y_counter : out natural range 0 to (v_res - 1);
		o_new_frame : out std_logic
  	);
end hdmi_generator;

architecture rtl of hdmi_generator is
	constant c_h_total : natural := h_res + v_fp + v_sync + v_bp - 1;
	signal s_h_count : natural range 0 to c_h_total := 0;
	signal s_hdmi_hs : std_logic; --signal de synchronisation horizontal qui détecte les nouvelles lignes

	begin
		process(i_clk, i_reset_n)
		begin
			if (i_reset_n = '0') then
				s_h_count <= 0;
			elsif (rising_edge(i_clk)) then
				if (s_h_count = c_h_total) then
					s_h_count <= 0;
					s_hdmi_hs <= '1';
				else
					s_h_count <= s_h_count + 1;
					s_hdmi_hs <= '0';
				end if;
			end if;
		end process;
		o_hdmi_hs <= s_hdmi_hs;
end architecture rtl;
