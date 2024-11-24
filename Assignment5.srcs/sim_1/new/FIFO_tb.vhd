library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO_tb is
end entity FIFO_tb;

architecture Behavioral of FIFO_tb is
    -- Constants
    constant DATA_WIDTH : integer := 32;    
    constant DEPTH      : integer := 1024;

    -- Signals
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal write_en   : std_logic := '0';
    signal read_en    : std_logic := '0';
    signal write_data : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal read_data  : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal full       : std_logic;
    signal empty      : std_logic;

    -- Component declaration
    component FIFO is
        generic (
            DATA_WIDTH : integer := 32;
            DEPTH      : integer := 1024
        );
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            write_en   : in  std_logic;
            read_en    : in  std_logic;
            write_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            read_data  : out std_logic_vector(DATA_WIDTH-1 downto 0);
            full       : out std_logic;
            empty      : out std_logic
        );
    end component;

begin
    -- Instantiate the FIFO component
    uut: FIFO
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            DEPTH      => DEPTH
        )
        port map (
            clk        => clk,
            reset      => reset,
            write_en   => write_en,
            read_en    => read_en,
            write_data => write_data,
            read_data  => read_data,
            full       => full,
            empty      => empty
        );

    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;  -- Clock period of 10 ns
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Test stimulus process
    stimulus : process
        variable i : integer;
    begin
        -- Reset the FIFO
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 10 ns;

        -- Task 1: Write data into FIFO until it is full
        write_en <= '1';
        write_data <= (others => '0');  -- Initialize with zeros
        for i in 0 to DEPTH - 1 loop
            -- Toggle data between all zeros and all ones
            if i < DEPTH / 2 then
                write_data <= (others => '0');
            else
                write_data <= (others => '1');
            end if;
            wait for 10 ns;
        end loop;
        write_en <= '0';
        wait for 20 ns;

        -- Task 1: Read data from FIFO until it is empty
        read_en <= '1';
        for i in 0 to DEPTH - 1 loop
            wait for 10 ns;
        end loop;
        read_en <= '0';
        wait for 20 ns;

        -- Task 2: Simultaneous write and read operations
        write_en <= '1';
        read_en  <= '1';
        write_data <= X"AA";  -- Fixed data pattern
        for i in 0 to 100 loop
            wait for 10 ns;
        end loop;
        write_en <= '0';
        read_en  <= '0';
        wait for 20 ns;

        -- Task 3: Change DATA_WIDTH to 32 bits
       

        -- End of simulation
        wait;
    end process;

end architecture Behavioral;
