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

![image](https://github.com/user-attachments/assets/c73680b1-bccb-4e28-8318-2fc6dfcd92c5)

On observe bien que lorsque le reset est à 1, o_hdmi_hs s'incrémente correctement. Lorsque le rest est à 0, o_hdmi_hs reste nul.

Pour la suite du programme nous avons choisi des h_res = 32 v_res = 24 dans le workbench en pour faciliter la visualisation en simulation.
Après considération, il s'avère que nos signaux HS et VS étaientt invesré (low au lieu de high) après correction, on obtient le chronogramme suivant : 

![image](https://github.com/user-attachments/assets/e5d50145-4151-44a5-923f-c569b4f8d8a3)

On voit bien les différentes zones d'activités de nos pixels avec HS et VS, HS a une période d'activation plus courte pour HS ce qui est cohérent car le comptage se fait ligne par ligne.
Notre signal enable est bien high quand HS et VS le sont.

On peut alors observer l'image suivante qui a été transmise par HDMI : 

![1735392400763](https://github.com/user-attachments/assets/302d1eeb-54ef-420c-a681-0fc4610edb68)

Les dégradés de couleurs sont cohérents car nos deux masques deux couleurs vert et bleu s'incrément respectivement avec les valeurs des compteurs de pixels verticaux et horizontaux.

### 2.2 Affichage Logo ENSEA

L'affichage du logo ENSEA par HDMI doit passer par l'utilisation d'une mémoire RAM dans laquelle sera stockée le logo.
La taille de la mémoire stockant le logo sera de 95x95 et chaque pixel et codé en nuance de gris sur 8 bits.
L'idée est changer la position du logo au cours du temps mais nous n'avons pas eu le temps d'implémenter cette feature.

![1735392400722](https://github.com/user-attachments/assets/bddddc55-b768-4037-94da-35f29f55b788)

