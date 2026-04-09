# DE1-waveform-gen

Cílem tohoto projektu je vytvořit funkční digitální generátor průběhů implementovaný na vývojové desce **Nexys A7-50T (revision D0)**. 

Generátor umožňuje uživateli přepínat mezi čtyřmi základními typy signálů:
* Harmonický průběh (Sinus)
* Obdélníkový průběh (Square)
* Trojúhelníkový průběh (Triangle)
* Pilovitý průběh (Sawtooth)

Frekvenci výstupního signálu lze nastavovat v rozsahu **od 1 Hz do 10 kHz**. Uživatelské rozhraní je řešeno pomocí tlačítek na desce pro výběr a úpravu parametrů, přičemž aktuální stav je zobrazován na sedmisegmentovém displeji. Editovaný parametr je pro lepší orientaci vizuálně indikován desetinnou tečkou.

## Blokové schéma

![Blokové schéma architektury generátoru](DE1-waveform-gen-block_diagram.png)

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
* **Nultý segment (DISP 0)** - Zobrazení jednotkové složky nastaveného kmitočtu.
* **První segment (DISP 1)** - Zobrazení desítkové složky nastaveného kmitočtu.
* **Druhý segment (DISP 2)** - Zobrazení stovkové složky nastaveného kmitočtu.
* **Třetí segment (DISP 3)** - Zobrazení tisícové složky nastaveného kmitočtu.
* **Sedmý segment (DISP 7)** - Indikace aktuálně zvoleného typu průběhu.

**Audio Výstup:**
* PWM modulovaný signál vyvedený do 3.5mm jack konektoru na desce (aktivní pouze při zapnutém `SW0`).
