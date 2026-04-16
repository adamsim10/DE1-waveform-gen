----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2026 16:12:49
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( clk : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnr : in STD_LOGIC;
           btnc : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           aud_pwm : out STD_LOGIC;
           aud_sd : out STD_LOGIC;
           dp : out std_logic);
end top;

architecture Behavioral of top is

    component  display_driver is
        port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            data  : in  std_logic_vector(31 downto 0);
            seg   : out std_logic_vector(6 downto 0);
            anode : out std_logic_vector(7 downto 0);
            blink : in  std_logic_vector(7 downto 0)
        );
    end component  display_driver;
    
    component  debounce is
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            btn_in      : in  std_logic;  -- Bouncey button input
            btn_state   : out std_logic;  -- Debounced level
            btn_press   : out std_logic;  -- 1-clock press pulse
            -- btn_release : out std_logic   -- 1-clock release pulse
            btn_hold    : out std_logic   -- 1-clock pulse on press + every 0.5s
        );
    end component  debounce;
    
    component  FreqToPhase is
    Port (
            clk      : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            freq_in  : in  STD_LOGIC_VECTOR(13 downto 0); -- 1 až 10 000
            phase_out: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component  FreqToPhase;
    
    component  MUX is
        Port ( SEL : in STD_LOGIC_VECTOR (1 downto 0);
               IN1 : in STD_LOGIC_VECTOR (7 downto 0);
               IN2 : in STD_LOGIC_VECTOR (7 downto 0);
               IN3 : in STD_LOGIC_VECTOR (7 downto 0);
               IN4 : in STD_LOGIC_VECTOR (7 downto 0);
               OUT1 : out STD_LOGIC_VECTOR (7 downto 0));
    end component  MUX;
    
    component  PWM is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               amplitude : in STD_LOGIC_VECTOR (7 downto 0);
               pwm : out STD_LOGIC);
    end component PWM;
    
    component  SAW_W is
        Port ( phase : in STD_LOGIC_VECTOR (7 downto 0);
               amplitude : out STD_LOGIC_VECTOR (7 downto 0));
    end component  SAW_W;
    
    component  SIN_W is
        Port ( phase : in STD_LOGIC_VECTOR (7 downto 0);
               amplitude : out STD_LOGIC_VECTOR (7 downto 0));
    end component  SIN_W;
    
    component  SQR_W is
        Port ( phase : in STD_LOGIC_VECTOR (7 downto 0);
               amplitude : out STD_LOGIC_VECTOR (7 downto 0));
    end component  SQR_W;
    
    component  TRI_W is
        Port ( phase : in STD_LOGIC_VECTOR (7 downto 0);
               amplitude : out STD_LOGIC_VECTOR (7 downto 0));
    end component  TRI_W;
    
    component  parameter is
        Port ( 
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;
        left : in STD_LOGIC;
        right : in STD_LOGIC;
        up : in STD_LOGIC;
        down : in STD_LOGIC;
        left_h : in STD_LOGIC;
        right_h : in STD_LOGIC;
        up_h : in STD_LOGIC;
        down_h : in STD_LOGIC;
        display : out STD_LOGIC_VECTOR (31 downto 0);
        blink : out STD_LOGIC_VECTOR (7 downto 0);
        freq : out STD_LOGIC_VECTOR (13 downto 0);
        waveform : out STD_LOGIC_VECTOR (1 downto 0)
               );
    end component parameter;
    
    signal sig_btnu_deb : std_logic;
    signal sig_btnd_deb : std_logic;
    signal sig_btnl_deb : std_logic;
    signal sig_btnr_deb : std_logic;
    signal sig_btnu_pressd_deb : std_logic;
    signal sig_btnd_pressd_deb : std_logic;
    signal sig_btnl_pressd_deb : std_logic;
    signal sig_btnr_pressd_deb : std_logic;
    signal sig_freq : std_logic_vector(13 downto 0);
    signal sig_sel : std_logic_vector (1 downto 0);
    signal sig_phase : std_logic_vector(7 downto 0);
    signal sig_amplitude : std_logic_vector(7 downto 0);
    signal sig_amplitude_SIN : std_logic_vector(7 downto 0);
    signal sig_amplitude_SAW : std_logic_vector(7 downto 0);
    signal sig_amplitude_SQR: std_logic_vector(7 downto 0);
    signal sig_amplitude_TRI: std_logic_vector(7 downto 0);
    signal sig_blink : std_logic_vector(7 downto 0);
    signal sig_display : std_logic_vector(31 downto 0);
    
begin

    -------------------------------------------------------------------------
    -- 1. PARAMETER SETTINGS (Logika nastavení frekvence a vlnového průběhu)
    -------------------------------------------------------------------------
    PARAMETER_0 : parameter
    port map (
        rst      => btnc,      
        clk      => clk,
        left     => sig_btnl_deb,          
        right    => sig_btnr_deb,          
        up       => sig_btnu_deb,          
        down     => sig_btnd_deb,
        left_h   => sig_btnl_pressd_deb,
        right_h  => sig_btnr_pressd_deb,
        up_h     => sig_btnu_pressd_deb,
        down_h   => sig_btnd_pressd_deb,     
        display  => sig_display,          
        blink    => sig_blink,          
        freq     => sig_freq,
        waveform => sig_sel           
    );

    -------------------------------------------------------------------------
    -- 2. DEBOUNCE UNITS (4x pro ošetření zákmitů tlačítek)
    -------------------------------------------------------------------------
    -- Debounce pro tlačítko UP
    DB_UP : debounce
    port map (
        clk       => clk,
        rst       => btnc,
        btn_in    => btnu,
        btn_state => sig_btnu_pressd_deb,
        btn_press => open,
        btn_hold  => sig_btnu_deb
    );

    -- Debounce pro tlačítko DOWN
    DB_DOWN : debounce
    port map (
        clk       => clk,
        rst       => btnc,
        btn_in    => btnd,
        btn_state => sig_btnd_pressd_deb,
        btn_press => open,
        btn_hold  => sig_btnd_deb
    );

    -- Debounce pro tlačítko LEFT
    DB_LEFT : debounce
    port map (
        clk       => clk,
        rst       => btnc,
        btn_in    => btnl,
        btn_state => sig_btnl_pressd_deb,
        btn_press => open,
        btn_hold  => sig_btnl_deb
    );

    -- Debounce pro tlačítko RIGHT
    DB_RIGHT : debounce
    port map (
        clk       => clk,
        rst       => btnc,
        btn_in    => btnr,
        btn_state => sig_btnr_pressd_deb,
        btn_press => open,
        btn_hold  => sig_btnr_deb
    );

    -------------------------------------------------------------------------
    -- 3. SIGNAL GENERATION (Frekvence -> Fáze -> Vlny)
    -------------------------------------------------------------------------
    FREQ_TO_PHASE0 : FreqToPhase
    port map (
        clk       => clk,
        rst       => btnc,
        freq_in   => sig_freq,
        phase_out => sig_phase          
    );

    SIN_W_0 : SIN_W
    port map (
        phase     => sig_phase,        
        amplitude => sig_amplitude_sin          
    );

    SAW_W_0 : SAW_W
    port map (
        phase     => sig_phase,         
        amplitude => sig_amplitude_saw         
    );

    TRI_W_0 : TRI_W
    port map (
        phase     => sig_phase,         
        amplitude => sig_amplitude_tri         
    );

    SQR_W_0 : SQR_W
    port map (
        phase     => sig_phase,         
        amplitude => sig_amplitude_sqr          
    );

    -------------------------------------------------------------------------
    -- 4. OUTPUT SELECTION & MODULATION (MUX a PWM)
    -------------------------------------------------------------------------
    MUX_0 : MUX
    port map (
        SEL  => sig_sel,              
        IN1  => sig_amplitude_SIN,              
        IN2  => sig_amplitude_SAW,              
        IN3  => sig_amplitude_TRI,              
        IN4  => sig_amplitude_SQR,              
        OUT1 => sig_amplitude              
    );

    PWM_0 : PWM
    port map (
        clk       => clk,
        rst       => btnc,
        amplitude => sig_amplitude,         
        pwm       => aud_pwm  
    );
    
               

    -------------------------------------------------------------------------
    -- 5. VISUALIZATION (7-segmentový displej)
    -------------------------------------------------------------------------
    DISPLAY_DRIVER_0 : display_driver
    port map (
        clk   => clk,
        rst   => btnc,
        data  => sig_display,            
        seg   => seg,          
        anode => an,           
        blink => sig_blink              
    );
    
    aud_sd <= sw(0);  
    
    dp <= '1';
    
end Behavioral;
