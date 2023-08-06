# frozen_string_literal: true

cheatsheet do
  title 'My Tmux Cheatsheet'
  docset_file_name 'my_tmux_cheatsheet'
  keyword 'mtc'
  introduction 'Examples of how to use tmux configured with my .tmux.conf file.'
  source_url 'https://github.com/dickdavis/dotfiles/blob/cheatsheets/my_tmux_cheatsheet.rb'

  category do
    id 'Customizations'

    entry do
      command '<C-b>'
      name 'Prefix to use for all tmux commands.'
    end

    entry do
      command '<C-b>r'
      name 'Reload tmux config.'
    end

    entry do
      command '<C-b><C-a>'
      name 'Cycle through window panes.'
    end

    entry do
      command '<C-b>|'
      name 'Split window into two side-by-side panes.'
    end

    entry do
      command '<C-b>-'
      name 'Split window into two stacked panes.'
    end

    entry do
      command '<C-b><M-k>'
      name 'Resize pane up 5 units.'
    end

    entry do
      command '<C-b><M-j>'
      name 'Resize pane down 5 units.'
    end

    entry do
      command '<C-b><M-h>'
      name 'Resize pane left 5 units.'
    end

    entry do
      command '<C-b><M-l>'
      name 'Resize pane right 5 units.'
    end
  end

  category do
    id 'Integrations'

    entry do
      command '<C-b>I'
      name 'Fetch and install plugin.'
    end

    entry do
      command '<C-b>U'
      name 'Update plugins.'
    end
  end

  notes <<-MARKDOWN
  For use with the ~/.tmux.conf file located [here](https://github.com/dickdavis/dotfiles/blob/master/.tmux.conf)
  MARKDOWN
end
