-- Lilypond editing
return {
  'martineausimon/nvim-lilypond-suite',
  opts = {
    lilypond = {
      mappings = {
        -- Set custom keybindings
        player = "<localleader>p",
        compile = "<localleader>c",
        open_pdf = "<localleader>o",
        hyphenation = "<localleader>h",
        -- Disable useless default keybindings
        switch_buffers = "<localleader>g",
        insert_version = nil,
        hyphenation_change_lang = nil,
        insert_hyphen = nil,
        add_hyphen = nil,
        del_next_hyphen = nil,
        del_prev_hyphen = nil,
      },
      options = {
        pitches_language = "deutsch",  -- highlight h
        hyphenation_language = "en_DEFAULT",
        output = "pdf",
        backend = nil,
        main_file = "main.ly",
        main_folder = "%:p:h",  -- % filename, p fullpath, h head
        include_dir = nil,
        diagnostics = false,
        pdf_viewer = "zathura",
      },
    },
    latex = {
      mappings = {
        compile = "<localleader>c",
        open_pdf = "<localleader>o",
        lilypond_syntax = "<localleader>s"
      },
      options = {
        lilypond_book_flags = nil,
        clean_logs = false,
        main_file = "main.tex",
        main_folder = "%:p:h",
        include_dir = nil,
        lilypond_syntax_au = "BufEnter",
        pdf_viewer = "zathura",
      },
    },
    texinfo = {
      mappings = {
        compile = "<localleader>c",
        open_pdf = "<localleader>o",
        lilypond_syntax = "<localleader>s"
      },
      options = {
        lilypond_book_flags = "--pdf",
        clean_logs = false,
        main_file = "main.texi",
        main_folder = "%:p:h",
        --include_dir = nil,
        lilypond_syntax_au = "BufEnter",
        pdf_viewer = "zathura",
      },
    },
    player = {
    mappings = {
      quit = "q",
      play_pause = "p",
      loop = "<A-l>",
      backward = "h",
      small_backward = "<S-h>",
      forward = "l",
      small_forward = "<S-l>",
      decrease_speed = "j",
      increase_speed = "k",
      halve_speed = "<S-j>",
      double_speed = "<S-k>"
    },
    options = {
      row = 1,
      col = "99%",
      width = "37",
      height = "1",
      border_style = "single",
      winhighlight = "Normal:Normal,FloatBorder:Normal",
      midi_synth = "fluidsynth",
      fluidsynth_flags = {
        "/usr/share/sounds/sf2/FluidR3_GM.sf2", "-g", "2"
      },
      timidity_flags = nil,
      audio_format = "mp3",
      mpv_flags = {
        "--msg-level=cplayer=no,ffmpeg=no,alsa=no",
        "--loop",
        "--config-dir=/dev/null"
        }
      },
    },
  }
}
