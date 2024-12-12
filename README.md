# 2425_ESE_TP_FPGA_FRICOT_CHAPART

## 2 Petit projet : Bouncing ENSEA Logo
### 2.1 Contrôleur HDMI
Analyse de l’entity :

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
    	);

Avec l'architecture suivante nous obtenons la simulation ci-dessous : 

![image](https://github.com/user-attachments/assets/a7688d4d-5314-4c54-b57e-caff2b8f9330)

![image](https://github.com/user-attachments/assets/ae89187d-1748-4b48-ab44-de0c51a02783)

On observe bien que lorsque le reset est à 1, o_hdmi_hs s'incrémente correctement. Lorsque le rest est à 0, o_hdmi_hs reste nul.
