# frozen_string_literal: true

cheatsheet do
  title 'My Vim Cheatsheet'
  docset_file_name 'my_vim_cheatsheet'
  keyword 'mvc'
  introduction 'Examples of how to use vim configured with my .vimrc file.'
  source_url 'https://github.com/dickdavis/dotfiles/blob/cheatsheets/my_vim_cheatsheet.rb'

  category do
    id 'Customizations'

    entry do
      command '<C-r>'
      name 'Search and replace the highlighted text with a replacement string.'
    end

    entry do
      command '<left>'
      name 'Cycle the active buffer left.'
    end

    entry do
      command '<right>'
      name 'Cycle the active buffer right.'
    end
  end

  category do
    id 'Integrations'

    entry do
      command '<leader>ru'
      name 'Dispatch the rubocop static analyzer for the current file.'
    end

    entry do
      command '<leader>re'
      name 'Dispatch the reek static analyzer for the current file.'
    end

    entry do
      command '<leader>a'
      name 'Dispatch test runner for all files.'
    end

    entry do
      command '<leader>f'
      name 'Dispatch test runner for current file.'
    end

    entry do
      command '<leader>t'
      name 'Dispatch the test runner for the test block under the cursor.'
    end

    entry do
      command '<leader>l'
      name 'Dispatch the test runner with the last set of tests executed.'
    end

    entry do
      command '<leader>d'
      name 'Search for the word under the cursor in corresponding Dash docset.'
    end

    entry do
      command '<C-c><C-c>'
      name 'Send text to a REPL.'
      notes 'Default behavior uses `vip`. For a single line, use `<S-v><C-c><C-c>`'
    end

    entry do
      command ':Ags'
      name 'Search for the provided input using `the_silver_searcher`.'
    end

    entry do
      command '<C-g>'
      name 'Accept codeium suggestion.'
    end

    entry do
      command '<C-x>'
      name 'Clear codeium suggestion.'
    end

    entry do
      command '<leader>c'
      name 'Launch codeium chat.'
    end

    entry do
      command '<Right>'
      name 'Cycle forwards through codeium suggestions.'
      notes 'Insert mode only.'
    end

    entry do
      command '<Left>'
      name 'Cycle backwards through codeium suggestions.'
      notes 'Insert mode only.'
    end
  end

  notes <<-MARKDOWN
  For use with the ~/.vimrc file located [here](https://github.com/dickdavis/dotfiles/blob/master/.vimrc)
  MARKDOWN
end
