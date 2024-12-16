library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hdmi_generator is
    generic (
        -- Resolution
        h_res   : natural := 720; -- Horizontal resolution in pixels
        v_res   : natural := 480; -- Vertical resolution in pixels

        -- Timings magic values (480p)
        h_sync  : natural := 61; -- Sync pulse (lines)
        h_fp    : natural := 58; -- Front porch (px) 
        h_bp    : natural := 18; -- Back porch (px)

        v_sync  : natural := 5; -- Sync pulse (lines)
        v_fp    : natural := 30; -- Front porch (px) 
        v_bp    : natural := 9  -- Back porch (px)
    );
    port (
        i_clk           : in std_logic;
        i_reset_n       : in std_logic;
        
        o_hdmi_hs       : out std_logic;
        o_hdmi_vs       : out std_logic;
        o_hdmi_de       : out std_logic;

        o_pixel_en      : out std_logic; -- Indicates valid pixel
        o_pixel_address : out natural range 0 to (h_res * v_res - 1); 
        o_x_counter     : out natural range 0 to (h_res - 1);
        o_y_counter     : out natural range 0 to (v_res - 1);
        o_new_frame     : out std_logic
    );
end hdmi_generator;

architecture rtl of hdmi_generator is
    -- Horizontal total pixels
    constant c_h_total : natural := h_res + h_fp + h_sync + h_bp ;
	 -- Vertical total pixels
    constant c_v_total : natural := v_res + v_fp + v_sync + v_bp ;

    -- Horizontal counter
    signal s_h_count : natural range 0 to c_h_total := 0;
	 -- Vertical counter
    signal s_v_count : natural range 0 to c_v_total := 0;
	 -- Indicate if we are in the Horizontal active pixel zone
	 signal s_h_act : std_logic;
	 -- Indicate if we are in the Vertical active pixel zone
	 signal s_v_act : std_logic;
	 
	 -- Counter for the pixel in the active zone
	 signal r_pixel_counter : natural range 0 to ((h_res * v_res) - 1)  := 0;
	 -- Counter for the pixel in the horizontal active zone
	 signal r_pixel_h_counter : natural range 0 to (h_res  - 1)  := 0;
	 -- Counter for the pixel in the vectial active zone
	 signal r_pixel_v_counter : natural range 0 to ( v_res - 1)  := 0;

begin
-- Horizontal counter process
process(i_clk, i_reset_n)
begin
    if (i_reset_n = '0') then
        s_h_count <= 0; -- Reset horizontal counter
        s_v_count <= 0; -- Reset vertical counter
        r_pixel_h_counter <= 0; -- Reset pixel counters
        r_pixel_v_counter <= 0;
        r_pixel_counter <= 0;
		  o_hdmi_hs    <= '1';
		  o_hdmi_vs    <= '1';
		  o_hdmi_de <= '0';

    elsif (rising_edge(i_clk)) then
        if (s_h_count = c_h_total) then
            s_h_count <= 0; -- Reset at the end of horizontal line
            if (s_v_count = c_v_total) then
                s_v_count <= 0; -- Reset at the end of vertical line
            else
                s_v_count <= s_v_count + 1; -- Increment vertical counter
					if (v_sync + v_fp = s_v_count ) then
						 s_v_act <= '1';
					elsif (s_v_count = v_sync + v_fp + v_res) then
						 s_v_act <= '0';
					end if;
					
            end if;
        else
            s_h_count <= s_h_count + 1; -- Increment horizontal counter
            if (h_sync + h_fp = s_h_count ) then
                s_h_act <= '1';
            elsif (s_h_count = h_sync + h_fp + h_res) then
                s_h_act <= '0';
            end if;
        end if;
			
		  --HS and VS logic
			if ((s_h_count >= h_sync) and (s_h_count /= c_h_total)) then
				o_hdmi_hs <= '1';
			else
				o_hdmi_hs <= '0';
			end if;
			
			if ((s_v_count >= v_sync) and (s_v_count /= c_v_total)) then
				o_hdmi_vs <= '1';
			else
				o_hdmi_vs <= '0';
			end if;
			
        -- Pixel counter logic
		  if ((s_v_act = '1') and (s_h_act = '1')) then
		  
			  if (r_pixel_h_counter = h_res - 1) then
					r_pixel_h_counter <= 0;
					if (r_pixel_h_counter = h_res - 1) then
						r_pixel_h_counter <= 0;
						
						if (r_pixel_v_counter = v_res -1) then
							r_pixel_v_counter <= 0;
						else
							r_pixel_v_counter <= r_pixel_v_counter + 1;
						end if;
					else
						r_pixel_h_counter <= r_pixel_h_counter + 1;
					end if;
			end if;
			-- absolute pixel counter
			if (r_pixel_counter = h_res * v_res - 1) then
				r_pixel_counter <= 0;
			else
				r_pixel_counter <= r_pixel_counter + 1;
			end if;			
	    end if;		
		 
--				if (r_pixel_h_counter = h_res - 1) then
--					r_pixel_h_counter <= 0;	
--			  elsif (s_h_act = '1' and s_v_act = '1') then
--					r_pixel_h_counter <= r_pixel_h_counter + 1;
--			  end if;
--	
--			  if (r_pixel_v_counter = v_res - 1) then
--					r_pixel_v_counter <= 0;
--			  elsif (s_h_act = '1' and s_v_act = '1') then
--					r_pixel_v_counter <= r_pixel_v_counter + 1;
--			  end if;
--	
--			  if (r_pixel_counter = h_res * v_res - 1) then
--					r_pixel_counter <= 0; -- Reset pixel counter
--			  elsif (s_h_act = '1' and s_v_act = '1') then
--					r_pixel_counter <= r_pixel_counter + 1; -- Increment pixel counter
--			  end if;
		o_hdmi_de <= s_v_act and s_h_act;

    end if;
end process;	 
	 o_x_counter <= r_pixel_h_counter;
	 o_y_counter <= r_pixel_v_counter;
	 o_pixel_en <= '1' when (s_v_act = '1') and (s_h_act = '1') else '0';
	 o_pixel_address <= r_pixel_counter;
	 o_new_frame <= '1' when (r_pixel_counter = h_res * v_res - 1) else '0';

end architecture rtl;
