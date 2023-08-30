# frozen_string_literal: true

cheatsheet do
  title 'My Kagi Cheatsheet'
  docset_file_name 'my_kagi_cheatsheet'
  keyword 'mkc'
  introduction 'Examples for using advanced features of Kagi search..'
  source_url 'https://github.com/dickdavis/dotfiles/blob/cheatsheets/my_kagi_cheatsheet.rb'

  category do
    id 'Bangs'

    entry do
      command '!git'
      name 'Searches github.com with the provided query (defaults to repository search.)'
      notes '!git ruby'
    end

    entry do
      command '!ghc'
      name 'Searches code examples on github.com with the provided query.'
      notes '!ghc fibonacci'
    end

    entry do
      command '!gist'
      name 'Searches code examples on gist.github.com with the provided query.'
      notes '!gist fibonacci'
    end

    entry do
      command '!so'
      name 'Searches stackoverflow.com with the provided query.'
      notes '!so how to do something'
    end

    entry do
      command '!gem'
      name 'Searches rubygems.org with the provided query.'
      notes '!gem devise'
    end

    entry do
      command '!npm'
      name 'Searches npmjs.com with the provided query.'
      notes '!npm lodash'
    end

    entry do
      command '!isup'
      name 'Searches downforeveryoneorjustme.com to see if the provided site is experiencing downtime.'
      notes '!isup dick.codes'
    end

    entry do
      command '!hn'
      name 'Searches Hacker News with the provided query.'
      notes '!hn rails'
    end

    entry do
      command '!lobsters'
      name 'Searches lobste.rs with the provided query.'
      notes '!lobsters postgresql'
    end

    entry do
      command '!books'
      name '(Custom) Searches bookshop.org with the provided query.'
      notes '!books how will you measure your life'
    end
  end

  notes <<-MARKDOWN
  For use with the [Kagi](https://kagi.com) search engine.
  MARKDOWN
end
