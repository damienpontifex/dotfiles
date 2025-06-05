return {
  -- Languages
  { 'hashivim/vim-terraform' },
  { 'pprovost/vim-ps1' },
  {
    'plasticboy/vim-markdown',
    event = 'VimEnter',
    branch = 'master',
    require = { 'godlygeek/tabular' },
  },
  { 'jparise/vim-graphql' },
  { 'towolf/vim-helm' }
}
