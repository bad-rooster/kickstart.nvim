return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = { 'Octo' },
  keys = {
    { '<leader>op', '<cmd>Octo pr list<cr>', desc = '[O]cto [p]r list' },
    { '<leader>or', '<cmd>Octo review start<cr>', desc = '[O]cto [r]eview start' },
    { '<leader>os', '<cmd>Octo review submit<cr>', desc = '[O]cto review [s]ubmit' },
    { '<leader>oc', '<cmd>Octo pr checkout<cr>', desc = '[O]cto pr [c]heckout' },
  },
  opts = {
    default_remote = { 'upstream', 'origin' },
    ssh_aliases = {},
    picker = 'telescope',
    enable_builtin = true,
    use_local_fs = false,
  },
}
