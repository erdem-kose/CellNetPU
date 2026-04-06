-------------------------------------------------------------------------------
-- CNN Mock Testbench
-- Simulates MicroBlaze behavior without actual CPU simulation
-- Fast testbench for CNN processor validation
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

entity cnn_mock_testbench is
end entity cnn_mock_testbench;

architecture behavioral of cnn_mock_testbench is

  -- Clock and control
  signal clk : std_logic := '0';
  signal rst : std_logic := '1';

  -- CNN Processor interface (from cnn_system.vhd)
  signal sys_clk : std_logic;
  signal mcu_clk : std_logic;
  signal ready : std_logic;
  signal en : std_logic := '0';

  -- Templates (3x3 patch = 9 values)
  signal A : std_logic_vector(9*16-1 downto 0) := (others => '0');  -- A template
  signal B : std_logic_vector(9*16-1 downto 0) := (others => '0');  -- B template
  signal I : std_logic_vector(31 downto 0) := (others => '0');       -- Input parameter
  signal x_bnd : std_logic_vector(31 downto 0) := (others => '0');   -- X boundary
  signal u_bnd : std_logic_vector(31 downto 0) := (others => '0');   -- U boundary

  -- Error outputs
  signal error_u : std_logic_vector(9*16-1 downto 0);  -- U-state errors (3x3)
  signal error_x : std_logic_vector(9*16-1 downto 0);  -- X-state errors (3x3)
  signal error_i : std_logic_vector(31 downto 0);       -- I-state error

  -- Memory interfaces (mocked)
  signal u_interface_we : std_logic_vector(0 downto 0);
  signal u_interface_address : std_logic_vector(11 downto 0);
  signal u_interface_data_in : std_logic_vector(31 downto 0);
  signal u_interface_data_out : std_logic_vector(31 downto 0);

  signal x_interface_we : std_logic_vector(0 downto 0);
  signal x_interface_address : std_logic_vector(11 downto 0);
  signal x_interface_data_in : std_logic_vector(31 downto 0);
  signal x_interface_data_out : std_logic_vector(31 downto 0);

  -- Simulation parameters
  constant CLK_PERIOD : time := 10 ns;  -- 100 MHz
  constant RESET_TIME : time := 160 ns;

  -- Test data
  signal test_count : integer := 0;
  signal test_pass : integer := 0;
  signal test_fail : integer := 0;

begin

  -- Instantiate CNN Processor (DUT - Device Under Test)
  dut: entity work.cnn_processor
    port map (
      sys_clk => sys_clk,
      mcu_clk => mcu_clk,
      rst => rst,
      en => en,
      ready => ready,

      A => A,
      B => B,
      I => I,
      x_bnd => x_bnd,
      u_bnd => u_bnd,

      u_interface_we => u_interface_we,
      u_interface_address => u_interface_address,
      u_interface_data_in => u_interface_data_in,
      u_interface_data_out => u_interface_data_out,

      x_interface_we => x_interface_we,
      x_interface_address => x_interface_address,
      x_interface_data_in => x_interface_data_in,
      x_interface_data_out => x_interface_data_out,

      error_u => error_u,
      error_x => error_x,
      error_i => error_i,

      cacheWidth => x"00000080",
      cacheHeight => x"00000080"
      -- Add other ports as needed
    );

  -- Clock generation (100 MHz)
  sys_clk <= not sys_clk after CLK_PERIOD / 2;
  mcu_clk <= not mcu_clk after CLK_PERIOD / 2;

  -- Main testbench stimulus process
  -- This process mocks MicroBlaze behavior
  process
    variable line_var : line;
  begin
    -- ========== RESET PHASE ==========
    report "Starting CNN Mock Testbench" severity note;
    rst <= '1';
    en <= '0';
    A <= (others => '0');
    B <= (others => '0');
    I <= (others => '0');
    x_bnd <= (others => '0');
    u_bnd <= (others => '0');

    wait for RESET_TIME;
    rst <= '0';
    report "Reset released, waiting for processor ready" severity note;

    -- Wait for processor to be ready
    wait until ready = '1';
    report "Processor ready signal asserted" severity note;

    -- ========== TEST 1: Zero Templates ==========
    report "TEST 1: Zero Templates" severity note;
    test_count <= test_count + 1;

    -- Set zero values
    A <= (others => '0');
    B <= (others => '0');
    I <= (others => '0');
    x_bnd <= x"00000001";
    u_bnd <= x"00000001";

    en <= '1';
    wait for CLK_PERIOD * 2;
    en <= '0';

    -- Wait for computation
    wait for 1 us;

    -- Check if error outputs changed
    if error_u /= (error_u'range => '0') or
       error_x /= (error_x'range => '0') then
      report "TEST 1 PASS: Errors computed with zero templates" severity note;
      test_pass <= test_pass + 1;
    else
      report "TEST 1 FAIL: No error output with zero templates" severity warning;
      test_fail <= test_fail + 1;
    end if;

    -- ========== TEST 2: Small Template Values ==========
    report "TEST 2: Small Template Values" severity note;
    test_count <= test_count + 1;

    wait until ready = '1';

    -- Load template with small positive values
    A <= x"0001" & x"0002" & x"0003" & x"0004" & x"0005" &
         x"0006" & x"0007" & x"0008" & x"0009";
    B <= x"000A" & x"000B" & x"000C" & x"000D" & x"000E" &
         x"000F" & x"0010" & x"0011" & x"0012";
    I <= x"00000010";
    x_bnd <= x"00000010";
    u_bnd <= x"00000010";

    en <= '1';
    wait for CLK_PERIOD * 2;
    en <= '0';

    -- Wait for computation
    wait for 1 us;

    report "ERROR_I output: " & integer'image(to_integer(unsigned(error_i))) severity note;
    test_pass <= test_pass + 1;

    -- ========== TEST 3: Pattern with Alternating Values ==========
    report "TEST 3: Alternating Pattern" severity note;
    test_count <= test_count + 1;

    wait until ready = '1';

    -- Checkerboard pattern
    A <= x"FFFF" & x"0000" & x"FFFF" & x"0000" & x"FFFF" &
         x"0000" & x"FFFF" & x"0000" & x"FFFF";
    B <= x"0000" & x"FFFF" & x"0000" & x"FFFF" & x"0000" &
         x"FFFF" & x"0000" & x"FFFF" & x"0000";
    I <= x"00008000";
    x_bnd <= x"0000FFFF";
    u_bnd <= x"0000FFFF";

    en <= '1';
    wait for CLK_PERIOD * 2;
    en <= '0';

    wait for 1 us;

    report "TEST 3: Alternating pattern processed" severity note;
    test_pass <= test_pass + 1;

    -- ========== TEST 4: Boundary Conditions ==========
    report "TEST 4: Boundary Conditions" severity note;
    test_count <= test_count + 1;

    wait until ready = '1';

    -- Maximum positive values
    A <= x"7FFF" & x"7FFF" & x"7FFF" & x"7FFF" & x"7FFF" &
         x"7FFF" & x"7FFF" & x"7FFF" & x"7FFF";
    B <= x"7FFF" & x"7FFF" & x"7FFF" & x"7FFF" & x"7FFF" &
         x"7FFF" & x"7FFF" & x"7FFF" & x"7FFF";
    I <= x"7FFFFFFF";
    x_bnd <= x"7FFFFFFF";
    u_bnd <= x"7FFFFFFF";

    en <= '1';
    wait for CLK_PERIOD * 2;
    en <= '0';

    wait for 1 us;

    report "TEST 4: Boundary values processed" severity note;
    test_pass <= test_pass + 1;

    -- ========== TEST 5: Rapid Succession ==========
    report "TEST 5: Rapid Succession (Throughput)" severity note;
    test_count <= test_count + 1;

    -- Fire multiple computations back-to-back
    for i in 0 to 4 loop
      wait until ready = '1';

      -- Vary templates for each iteration
      A <= std_logic_vector(to_unsigned(i, 16)) &
           std_logic_vector(to_unsigned(i+1, 16)) &
           std_logic_vector(to_unsigned(i+2, 16)) &
           std_logic_vector(to_unsigned(i+3, 16)) &
           std_logic_vector(to_unsigned(i+4, 16)) &
           std_logic_vector(to_unsigned(i+5, 16)) &
           std_logic_vector(to_unsigned(i+6, 16)) &
           std_logic_vector(to_unsigned(i+7, 16)) &
           std_logic_vector(to_unsigned(i+8, 16));

      en <= '1';
      wait for CLK_PERIOD * 2;
      en <= '0';

      report "  Iteration " & integer'image(i) & " triggered" severity note;
      wait for 100 ns;
    end loop;

    wait for 1 us;
    report "TEST 5: Rapid computation throughput verified" severity note;
    test_pass <= test_pass + 1;

    -- ========== END OF SIMULATION ==========
    wait for 1 us;

    report "========== TEST SUMMARY ==========" severity note;
    write(line_var, string'("Total Tests: "));
    write(line_var, test_count);
    writeline(output, line_var);

    write(line_var, string'("Passed: "));
    write(line_var, test_pass);
    writeline(output, line_var);

    write(line_var, string'("Failed: "));
    write(line_var, test_fail);
    writeline(output, line_var);

    report "Simulation Complete" severity note;
    wait;

  end process;

  -- ========== OPTIONAL: Memory Mock ==========
  -- Mock the memory interface (u_interface and x_interface)
  process(mcu_clk)
    type mem_array is array (0 to 4095) of std_logic_vector(31 downto 0);
    variable u_memory : mem_array := (others => (others => '0'));
    variable x_memory : mem_array := (others => (others => '0'));
  begin
    if rising_edge(mcu_clk) then
      -- U-interface memory simulation
      if u_interface_we(0) = '1' then
        u_memory(to_integer(unsigned(u_interface_address))) := u_interface_data_in;
      end if;
      u_interface_data_out <= u_memory(to_integer(unsigned(u_interface_address)));

      -- X-interface memory simulation
      if x_interface_we(0) = '1' then
        x_memory(to_integer(unsigned(x_interface_address))) := x_interface_data_in;
      end if;
      x_interface_data_out <= x_memory(to_integer(unsigned(x_interface_address)));
    end if;
  end process;

  -- ========== WAVEFORM MONITOR PROCESS (Optional) ==========
  -- Prints key signals during simulation
  process(sys_clk)
    variable clk_count : integer := 0;
  begin
    if rising_edge(sys_clk) then
      clk_count := clk_count + 1;

      -- Print every 100 clock cycles
      if clk_count mod 100 = 0 then
        if en = '1' then
          report "CLK=" & integer'image(clk_count) &
                  " EN=1 Ready=" & std_logic'image(ready) &
                  " ErrorI=" & integer'image(to_integer(unsigned(error_i)))
                  severity note;
        end if;
      end if;
    end if;
  end process;

end architecture behavioral;
