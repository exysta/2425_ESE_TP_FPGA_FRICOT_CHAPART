# 2425_ESE_TP_FPGA_FRICOT_CHAPART

Analysez l’entity :
— Quel est le rôle des différents paramètres définis en generic ?
— Quel est leur unité ?

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
