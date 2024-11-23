library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO is
    generic (
        DATA_WIDTH : integer := 8;     -- Width of the data bus
        DEPTH      : integer := 512    -- Depth of the FIFO (number of entries)
    );
    port (
        clk        : in  std_logic;    -- Clock signal
        reset      : in  std_logic;    -- Synchronous reset signal
        write_en   : in  std_logic;    -- Write enable signal
        read_en    : in  std_logic;    -- Read enable signal
        write_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Data input
        read_data  : out std_logic_vector(DATA_WIDTH-1 downto 0);  -- Data output
        full       : out std_logic;    -- FIFO full flag
        empty      : out std_logic     -- FIFO empty flag
    );
end entity FIFO;

architecture Behavioral of FIFO is

    -- Calculate the address width based on DEPTH
    function clog2(x : integer) return integer is
        variable res : integer := 0;
        variable val : integer := x - 1;
    begin
        while val > 0 loop
            val := val / 2;
            res := res + 1;
        end loop;
        return res;
    end function;

    constant ADDR_WIDTH : integer := clog2(DEPTH);

    -- Memory array to store FIFO data
    type memory_type is array (0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mem : memory_type := (others => (others => '0'));

    -- Pointers and counter
    signal write_ptr : unsigned(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal read_ptr  : unsigned(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal count     : unsigned(ADDR_WIDTH downto 0)   := (others => '0');  -- Extra bit for full detection

    -- Flags
    signal full_reg  : std_logic := '0';
    signal empty_reg : std_logic := '1';

begin

    -- Output assignments
    full  <= full_reg;
    empty <= empty_reg;

    -- Synchronous process for FIFO operations
    process(clk)
    begin
        if rising_edge(clk) then
            -- Synchronous reset
            if reset = '1' then
                write_ptr <= (others => '0');
                read_ptr  <= (others => '0');
                count     <= (others => '0');
                full_reg  <= '0';
                empty_reg <= '1';
                read_data <= (others => '0');
            else
                -- Write operation
                if (write_en = '1') and (full_reg = '0') then
                    mem(to_integer(write_ptr)) <= write_data;
                    write_ptr <= write_ptr + 1;
                    count <= count + 1;
                end if;

                -- Read operation
                if (read_en = '1') and (empty_reg = '0') then
                    read_data <= mem(to_integer(read_ptr));
                    read_ptr <= read_ptr + 1;
                    count <= count - 1;
                end if;

                -- Update full and empty flags
                if count = to_unsigned(DEPTH, count'length) then
                    full_reg <= '1';
                else
                    full_reg <= '0';
                end if;

                if count = to_unsigned(0, count'length) then
                    empty_reg <= '1';
                else
                    empty_reg <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture Behavioral;
