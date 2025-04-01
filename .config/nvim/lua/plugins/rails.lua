return {
  "tpope/vim-rails",
  config = function()
    vim.g.rails_projections = {
      ["app/controllers/*_controller.rb"] = {
        ["command"] = "controller",
        ["test"] = {
          "spec/requests/{}_controller_spec.rb"
        }
      }
    }
  end
}
