# frozen_string_literal: true

cheatsheet do
  title 'My Neovim Cheatsheet'
  docset_file_name 'my_neovim_cheatsheet'
  keyword 'mnc'
  introduction 'Examples of how to use neovim configured with my init.lua file.'
  source_url 'https://github.com/dickdavis/dotfiles/blob/cheatsheets/my_neovim_cheatsheet.rb'

  category do
    id 'Core Navigation'

    entry do
      command '<left>'
      name 'Cycle the active buffer left.'
    end

    entry do
      command '<right>'
      name 'Cycle the active buffer right.'
    end

    entry do
      command 'w!!'
      name 'Write the current file with sudo permissions.'
      notes 'Used in command mode.'
    end
  end

  category do
    id 'Search'

    entry do
      command '<C-r>'
      name 'Search and replace the highlighted text with a replacement string.'
      notes 'Visual mode only.'
    end

    entry do
      command '<leader>ff'
      name 'Find files with Telescope.'
    end

    entry do
      command '<leader>fg'
      name 'Live grep search with Telescope.'
    end

    entry do
      command '<leader>fb'
      name 'Browse buffers with Telescope.'
    end

    entry do
      command '<leader>fh'
      name 'Search help tags with Telescope.'
    end
  end

  category do
    id 'LSP Features'

    entry do
      command '<space>e'
      name 'Show diagnostics in a floating window.'
    end

    entry do
      command '[d'
      name 'Go to previous diagnostic.'
    end

    entry do
      command ']d'
      name 'Go to next diagnostic.'
    end

    entry do
      command '<space>q'
      name 'Send diagnostics to location list.'
    end

    entry do
      command 'gD'
      name 'Go to declaration.'
    end

    entry do
      command 'gd'
      name 'Go to definition.'
    end

    entry do
      command 'K'
      name 'Show hover information.'
    end

    entry do
      command 'gi'
      name 'Go to implementation.'
    end

    entry do
      command '<C-k>'
      name 'Show signature help.'
    end

    entry do
      command '<space>wa'
      name 'Add workspace folder.'
    end

    entry do
      command '<space>wr'
      name 'Remove workspace folder.'
    end

    entry do
      command '<space>wl'
      name 'List workspace folders.'
    end

    entry do
      command '<space>D'
      name 'Go to type definition.'
    end

    entry do
      command '<space>rn'
      name 'Rename symbol.'
    end

    entry do
      command '<space>ca'
      name 'Code action.'
      notes 'Works in normal and visual modes.'
    end

    entry do
      command 'gr'
      name 'Show references.'
    end

    entry do
      command '<space>f'
      name 'Format buffer.'
    end
  end

  category do
    id 'Code Completion'

    entry do
      command '<C-Space>'
      name 'Trigger completion menu.'
    end

    entry do
      command '<Tab>'
      name 'Select next completion item.'
    end

    entry do
      command '<S-Tab>'
      name 'Select previous completion item.'
    end

    entry do
      command '<C-b>'
      name 'Scroll docs backward.'
    end

    entry do
      command '<C-f>'
      name 'Scroll docs forward.'
    end

    entry do
      command '<C-e>'
      name 'Cancel completion.'
    end

    entry do
      command '<CR>'
      name 'Confirm selection.'
    end
  end

  category do
    id 'Testing'

    entry do
      command '<leader>tn'
      name 'Run nearest test.'
    end

    entry do
      command '<leader>tf'
      name 'Run current test file.'
    end

    entry do
      command '<leader>ts'
      name 'Run entire test suite.'
    end

    entry do
      command '<leader>to'
      name 'Open test output.'
    end

    entry do
      command '<leader>tO'
      name 'Toggle output panel.'
    end

    entry do
      command '<leader>tS'
      name 'Toggle summary panel.'
    end

    entry do
      command '<leader>tw'
      name 'Toggle test watching.'
    end

    entry do
      command '<leader>tr'
      name 'Run last test.'
    end

    entry do
      command '[t'
      name 'Jump to previous failed test.'
    end

    entry do
      command ']t'
      name 'Jump to next failed test.'
    end
  end

  category do
    id 'Git'

    entry do
      command ']c'
      name 'Go to next git hunk.'
    end

    entry do
      command '[c'
      name 'Go to previous git hunk.'
    end

    entry do
      command '<leader>hs'
      name 'Stage git hunk.'
    end

    entry do
      command '<leader>hr'
      name 'Reset git hunk.'
    end

    entry do
      command '<leader>hS'
      name 'Stage git buffer.'
    end

    entry do
      command '<leader>hu'
      name 'Undo stage git hunk.'
    end

    entry do
      command '<leader>hR'
      name 'Reset git buffer.'
    end

    entry do
      command '<leader>hp'
      name 'Preview git hunk.'
    end

    entry do
      command '<leader>hb'
      name 'Git blame line.'
    end
  end

  category do
    id 'Documentation'

    entry do
      command '<leader>d'
      name 'Search for the word under the cursor in Dash.'
    end
  end

  notes <<-MARKDOWN
  For use with the neovim configuration located at ~/.config/nvim
  MARKDOWN
end
