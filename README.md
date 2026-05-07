# DE1-waveform-gen

Cílem tohoto projektu je vytvořit funkční digitální generátor průběhů implementovaný na vývojové desce **Nexys A7-50T**. 

Generátor umožňuje uživateli přepínat mezi čtyřmi základními typy signálů:
* Harmonický průběh (Sinus)
* Obdélníkový průběh (Square)
* Trojúhelníkový průběh (Triangle)
* Pilovitý průběh (Sawtooth)

Frekvenci výstupního signálu lze nastavovat v rozsahu **od 1 Hz do 10 kHz**, avšak doporučený interval je od 50 Hz do 5 kHz, kvůli zkreslení které je způsobeno interním integrovaným filtrem. Nastavování frekvence je ošetřeno proti překročení výše uvedených mezí, při pokusu o jejich překonání je automaticky nastavena limitní hodnota. Uživatelské rozhraní je řešeno pomocí tlačítek na desce pro výběr a úpravu parametrů, přičemž aktuální stav je zobrazován na sedmisegmentovém displeji. Editovaný parametr je pro lepší orientaci vizuálně indikován blikáním segmentu. Při přechodu z devítky na nulu či opačně při nastavování velikosti frekvence nedochází k přetékání.

Autoři: Adam Šimůnek, Šimon Tokarčík

## Demonstrace funkčnosti (videa)

* [Demonstrace funkčnosti 1](https://drive.google.com/file/d/11tJnr2geuAP9pd2jWXz6jPwQipX2imMT/view?usp=drive_link)
* [Demonstrace funkčnosti 2](https://drive.google.com/file/d/1TCETFFSu3PGTV68iCnh4JQiSy-RXiHOn/view?usp=drive_link)
* [Demonstrace resetu](https://drive.google.com/file/d/1SbjA9Zaj2S-D-U9g994sHcU0mNFik6pN/view?usp=drive_link)

## Blokové schéma

**Původní koncept:**
![Původní blokové schéma generátoru](DE1-waveform-gen-block_diagram.png)

**Konečné provedení:**
![Výsledné blokové schéma generátoru](DE1-waveform-gen-block_diagram_v2.png)

**Elaborated design:**
![Elaborated design z Vivada](simulace/elaborated_design_schemaic.png)

## Vstupy

Ovládání je navrženo pomocí integrovaných tlačítek a přepínačů na desce Nexys:

**Tlačítka:**
* **`BTNR`** - Výběr parametru pro modifikaci (posun vpřed).
* **`BTNL`** - Výběr parametru pro modifikaci (posun vzad).
* **`BTNU`** - Modifikace zvoleného parametru (inkrementace / +1).
* **`BTND`** - Modifikace zvoleného parametru (dekrementace / -1).
* **`BTNC`** - Reset systému do výchozího nastavení.

**Přepínače:**
* **`SW0`** - Hlavní vypínač pro povolení/zakázání audio výstupu (`AUD_SD`, pin D12).

## Výstupy

Nastavené parametry a generovaný signál jsou vyvedeny na následující periferie:

**Sedmisegmentový displej:**
* **Nultý segment (DISP 0)**  - Zobrazení jednotkové složky nastaveného kmitočtu.
* **První segment (DISP 1)**  - Zobrazení desítkové složky nastaveného kmitočtu.
* **Druhý segment (DISP 2)**  - Zobrazení stovkové složky nastaveného kmitočtu.
* **Třetí segment (DISP 3)**  - Zobrazení tisícové složky nastaveného kmitočtu.
* **Čtvrtý segment (DISP 4)** - Zobrazení desetitisícové složky nastaveného kmitočtu.
* **Sedmý segment (DISP 7)**  - Indikace aktuálně zvoleného typu průběhu.

**Audio Výstup:**
* PWM modulovaný signál vyvedený do 3.5mm jack konektoru na desce (aktivní pouze při zapnutém `SW0`).

## Simulace

**Debounce**
![Debounce](simulace/debounce%20po%20úpravě%20pro%20dlouhé%20stisknutí.png)
Upravený debounce obsahuje výstup btn_hold, který při držení tlačítka opakovaně generuje impulzy s nastavenou periodou.

**Výběr segmentů**
![Výběrový registr](simulace/přetekání%20výběrové%20registru%20digitů.png)
Přepínání parametru k modifikaci pomocí tlačítek bylo nutné ošetřit, aby se zobrazovaly na správném segmentu. V simulaci je vidět přetékání registru pro výběr segmentu, kde přepínáme mezi modifikací velikosti frekvence (segmenty 0, 1, 2, 3, 4) a modifikací zvoleného průběhu (segment 7), segmenty 5 a 6 vynecháváme. Simulace byla provedena v obou směrech přepínání.

**Blikání segmentu**
![Blikání](simulace/simulace%20vypínání%20vybraného%20segmentu%20s%2050%20střídou.png)
Pro lepší orientaci uživatele v právě zvoleném parametru segment zvoleného parametru bliká.

**Ošetření frekvence**
![Ošetření frekvence](simulace/ošetření%20velikostí%20frekvncí.png)
Při nastavení nulové frekvence uživatelem je automaticky nastavená frekvence 1 Hz (ošetření lze vidět v první polovině simulace). V případě, že by se uživatel pokoušel nastavit frekvenci větší než maximum (10 kHz), pak se provede automatické ošetření pro zpětné přenastavení na maximální kmitočet (ošetření lze pozorovat v druhé polovině simulace).

**Převod frekvence na fázový krok**
![Převod frekvence](simulace/simulace%20převodu%20frekvnce%20do%20posunu%20na%20průběhu.png)
V závislosti na frekvenci se mění rychlost změny fáze průběhu

**Převod amplitudy průběhu na PWM**
![Převod na PWM](simulace/simulace%20pwm.png)
Pulzně šířková modulace je tvořena podle velikosti amplitudy zvoleného průběhu 

**Harmonický průběh**
![Harmonický průběh](simulace/simulace_harmonického_průběhu.png)

**Pilovitý průběh**
![Pilovitý průběh](simulace/simulace_pilovitého_průběhu.png)

**Trojúhelníkový průběh**
![Trojúhelníkový průběh](simulace/simulace_trojúhelníkového_průběhu.png)

**Obdélníkový průběh**
![Obdélníkový průběh](simulace/simulace_obdélníkového_průběhu.png)

## Zdrojové kódy a odkazy

* [Top level: top.vhd](projekt/projekt.srcs/sources_1/new/top.vhd)
* [Debounce: debounce.vhd](projekt/projekt.srcs/sources_1/new/debounce.vhd)
* [Display driver: display_driver.vhd](projekt/projekt.srcs/sources_1/new/dislplay_driver.vhd)
* [Clock enable: clk_en.vhd](projekt/projekt.srcs/sources_1/new/clk_en.vhd)
* [Bin2Seg: bin2seg.vhd](projekt/projekt.srcs/sources_1/new/bin2seg.vhd)
* [Counter: counter.vhd](projekt/projekt.srcs/sources_1/new/counter.vhd)
* [Hlavní logický blok: parameter.vhd](projekt/projekt.srcs/sources_1/new/parameter.vhd)
* [Převod frekvence na fázi: FreqToPhase.vhd](projekt/projekt.srcs/sources_1/new/FreqToPhase.vhd)
* [Multiplexer: MUX.vhd](projekt/projekt.srcs/sources_1/new/MUX.vhd)
* [Harmonický průběh: SIN_W.vhd](projekt/projekt.srcs/sources_1/new/SIN_W.vhd)
* [Pilovitý průběh: SAW_W.vhd](projekt/projekt.srcs/sources_1/new/SAW_W.vhd)
* [Trojúhelníkový průběh: TRI_W.vhd](projekt/projekt.srcs/sources_1/new/TRI_W.vhd)
* [Obdélníkový průběh: SQR_W.vhd](projekt/projekt.srcs/sources_1/new/SQR_W.vhd)
* [Převod amplitudy na PWM: PWM.vhd](projekt/projekt.srcs/sources_1/new/PWM.vhd)

Odkaz na plakát projektu
* [PDF plakát velikosti A3](DE1-waveform-gen_poster.pdf)

## Reporty

**Využití zdrojů po syntéze**
![Využití zdrojů po syntéze](simulace/resource_utilization_post-syn.png)

**Využití zdrojů po implementaci**
![Využití zdrojů po implementaci](simulace/resource_utilization_post-impl.png)

**Využití zdrojů po implementaci (graf)**
![Využití zdrojů po implementaci graf](simulace/resource_utilization_post-impl_graph.png)

## Reference a zdroje

Komponenty Debounce, Display driver, Clock enable, Bin2Seg, Counter:
* [https://github.com/tomas-fryza/vhdl-examples/tree/master](https://github.com/tomas-fryza/vhdl-examples/tree/master)
(Debounce a Display driver byly následně upraveny pro naše potřeby)

Během práce byla využita AI [Google Gemini](https://gemini.google.com/app) pro vytvoření look-up tabulky harmonického průběhu a konzultace

Testbenche pro simulace byly automaticky předpřipraveny:
* [https://vhdl.lapinoo.net](https://vhdl.lapinoo.net)
