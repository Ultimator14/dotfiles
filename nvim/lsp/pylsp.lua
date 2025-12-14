--[
-- Language: Python
-- Server: pylsp
-- installed by mason
--  :MasonInstall python-lsp-server
--  :PylspInstall pylsp-mypy python-lsp-ruff pylint-venv
--]
return {
  --cmd = { "pylsp", "-vvv", "--log-file", "/home/jbreig/nvim_lsp.log"}, -- Debug log , remove in production
  settings = {
    pylsp = {
      plugins = {
        -- extensive code linting
        pylint = {
          enabled = true,
          args = {"--max-line-length 120", "--init-hook='import pylint_venv; pylint_venv.inithook(quiet=True)'"}
        },
        -- very fast linter, replaces flake8 and others
        ruff = {
          enabled = true,       -- 3rd party
          lineLength = 120,
          -- list of all rules https://beta.ruff.rs/docs/rules/
          select = {
            "F",                        -- pyflakes
            "E", "W",                   -- pycodestyle (error, warning)
            "C90",                      -- mccabe (complexty)
            "I",                        -- isort (import sorting)
            "N",                        -- pep8-naming
            --"D",                      -- pydocstyle
            "UP",                       -- pyupgrade (newer syntax)
            "YTT",                      -- sys.version misuse
            --"ANN",                    -- missing function annotations
            "S",                        -- bandit (security)
            "BLE",                      -- blind except
            "FBT",                      -- boolean trap
            "B",                        -- bugbear
            "A",                        -- name shadowing
            "COM",                      -- commas
            "C4",                       -- unnecessary stuff
            "DTZ",                      -- datetime
            "DJ",                       -- django
            "EM",                       -- errmsg
            --"EXE",                    -- shebang
            "ISC",                      -- implicit string concat
            "ICN",                      -- import conventions
            "G",                        -- logging format
            "INP",                      -- implicit namespace package
            "PIE",                      -- unnecessary stuff
            --"T20",                    -- find print statements
            "PYI",                      -- typing
            "PT",                       -- pytest
            "Q",                        -- quotes
            "RSE",                      -- unnecessary raise exception stuff
            "RET",                      -- unnecessary return stuff
            "SLF",                      -- self access
            "SIM",                      -- simplify
            "TID",                      -- tidy imports
            "TCH",                      -- type checking
            "INT",                      -- printf
            "ARG",                      -- unused arguments
            --"PTH",                    -- use pathlib
            --"ERA",                    -- commented code
            "PD",                       -- pandas code
            "PGH",                      -- pygrep hooks
            --"PLC", "PLE", "PLR", "PLW"-- pylint
            "TRY",                      -- tryceratops (exception anti pattern)
            "NPY",                      -- numpy
            "RUF"                       -- ruf rules
          },
          formatEnabled = true,
          format = { "I" }              -- autocorrect on reformat
        },
        -- completion and renaming
        rope_completion = {
          enabled = false        -- disabled by default, 3rd party since v1.12.0
                                 -- causes pylsp to hang with 100% cpu, disable for now
        },
        -- type checker
        pylsp_mypy = {
          enabled = true        -- 3rd party
        },

        -- error checking, replaced by ruff
        flake8 = { enabled = false },
        -- linter for docstring style checking (mostly included in pylint)
        pydocstyle = { enabled = false },
        -- linter for style checking (included in flake8/ruff)
        pycodestyle = { enabled = false },
        -- linter for complexity (included in flake8/ruff)
        mccabe = { enabled = false },
        -- linter for errors (included in flake8/ruff)
        pyflakes = { enabled = false },
        -- code formatting (disable in favor of yapf)
        autopep8 = { enabled = false },
        -- code formatting (disable in favor of black)
        yapf = { enabled = false }
        -- code formatter (replaced by ruff-format)
        --black = {
        --  enabled = true,       -- 3rd party
        --  line_length = 120
        --},
      }
    }
  }
}
