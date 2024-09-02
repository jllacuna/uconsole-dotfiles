local opts = {
  solargraph = {
    diagnostics = true,
    formatting = true,
  },
}

-- Uses the rubocop linter https://rubocop.org/
-- Diagnostics can be a bit excessive
-- Can configure diagnostics with a .rubocop.yml file in the project root
-- See configuration documentation: https://docs.rubocop.org/rubocop/configuration.html
-- See default configuration: https://github.com/rubocop/rubocop/blob/master/config/default.yml

return opts
