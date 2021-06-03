module('walnut.pcfg.axring', package.seeall)

vim.g.axring_rings = {
  { 'true', 'false' },
  { 'True', 'False' },
  { 'OFF', 'ON' },
  { 'YES', 'NO' },
  { '||', '&&' },
}

vim.g.axring_rings_cpp = {
  { 'Debug', 'Info', 'Warn', 'Error', 'Fatal' },
  { 'first', 'second' },
  { 'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t' },
  { 'htonl', 'ntohl' },
  { 'htons', 'ntohs' },
  { 'ASSERT_EQ', 'ASSERT_NE' },
  { 'EXPECT_EQ', 'EXPECT_NE' },
  { '==', '!=' },
  { 'static_cast', 'dynamic_cast', 'reinterpret_cast' },
}

