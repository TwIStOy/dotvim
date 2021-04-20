module('walnut.pcfg.axring', package.seeall)

local set_g_var = vim.api.nvim_set_var

set_g_var('axring_rings', {
  { 'true', 'false' },
  { 'True', 'False' },
  { 'OFF', 'ON' },
  { 'YES', 'NO' },
  { '||', '&&' },
})

set_g_var('axring_rings_cpp', {
  { 'Debug', 'Info', 'Warn', 'Error', 'Fatal' },
  { 'first', 'second' },
  { 'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t' },
  { 'htonl', 'ntohl' },
  { 'htons', 'ntohs' },
  { 'ASSERT_EQ', 'ASSERT_NE' },
  { 'EXPECT_EQ', 'EXPECT_NE' },
})
