module gnu.readline;

import core.stdc.stdio;

extern (C)
{
    alias Function = int function();
    alias VFunction = void function();
    alias CPFunction = char* function();
    alias CPPFunction = char** function();
    alias rl_command_func_t = int function(int, int);
    alias rl_compentry_func_t = char* function(const(char)*, int, int);
    alias rl_completion_func_t = char** function(const(char)*, int, int);
    alias rl_quote_func_t = char* function(char *, int, char *);
    alias rl_dequote_func_t = char* function(char *, int);
    alias rl_compignore_func_t = int function(char **);
    alias rl_compdisp_func_t = void function(char **, int, int);
    /* Type for input and pre-read hook functions like rl_event_hook */
    alias rl_hook_func_t = int function();

    /* Input function type */
    alias rl_getc_func_t = int function(FILE *);

    /* Generic function that takes a character buffer (which could be the readline
       line buffer) and an index into it (which could be rl_point) and returns
       an int. */
    alias rl_linebuf_func_t = int function(char *, int);

    /* `Generic' function pointer typedefs */
    alias rl_intfunc_t = int function(int);
    alias rl_ivoidfunc_t = rl_hook_func_t;
    alias rl_icpfunc_t = int function(char *);
    alias rl_icppfunc_t = int function(char **);

    alias rl_voidfunc_t = void function();
    alias rl_vintfunc_t = void function(int);
    alias rl_vcpfunc_t = void function(char *);
    alias rl_vcppfunc_t = void function(char **);

    alias rl_cpvfunc_t = char *function();
    alias rl_cpifunc_t = char *function(int);
    alias rl_cpcpfunc_t = char *function(char  *);
    alias rl_cpcppfunc_t = char *function(char  **);


    struct _keymap_entry 
    {
        char type;
        rl_command_func_t function_;
    }
    alias KEYMAP_ENTRY = _keymap_entry;

/* This must be large enough to hold bindings for all of the characters
   in a desired character set (e.g, 128 for ASCII, 256 for ISO Latin-x,
   and so on) plus one for subsequence matching. */
enum KEYMAP_SIZE = 257;
enum ANYOTHERKEY = KEYMAP_SIZE-1;

alias KEYMAP_ENTRY_ARRAY = KEYMAP_ENTRY[KEYMAP_SIZE];
alias Keymap = KEYMAP_ENTRY*;

/* The values that TYPE can have in a keymap entry. */
enum ISFUNC = 0;
enum ISKMAP = 1;
enum ISMACR = 2;

extern __gshared KEYMAP_ENTRY_ARRAY emacs_standard_keymap, emacs_meta_keymap, emacs_ctlx_keymap;
extern __gshared KEYMAP_ENTRY_ARRAY vi_insertion_keymap, vi_movement_keymap;

/* Return a new, empty keymap.
   Free it with free() when you are done. */
Keymap rl_make_bare_keymap();

/* Return a new keymap which is a copy of MAP. */
Keymap rl_copy_keymap(Keymap);

/* Return a new keymap with the printing characters bound to rl_insert,
   the lowercase Meta characters bound to run their equivalents, and
   the Meta digits bound to produce numeric arguments. */
Keymap rl_make_keymap();

/* Free the storage associated with a keymap. */
void rl_discard_keymap(Keymap);

/* These functions actually appear in bind.c */

/* Return the keymap corresponding to a given name.  Names look like
   `emacs' or `emacs-meta' or `vi-insert'.  */
Keymap rl_get_keymap_by_name(const(char)*);

/* Return the current keymap. */
Keymap rl_get_keymap();

/* Set the current keymap to MAP. */
void rl_set_keymap(Keymap);
 


    /* Readline data structures. */

    /* Maintaining the state of undo.  We remember individual deletes and inserts
       on a chain of things to do. */

    /* The actions that undo knows how to undo.  Notice that UNDO_DELETE means
       to insert some text, and UNDO_INSERT means to delete some text.   I.e.,
       the code tells undo what to undo, not how to undo it. */
    enum undo_code { UNDO_DELETE, UNDO_INSERT, UNDO_BEGIN, UNDO_END };

    /* What an element of THE_UNDO_LIST looks like. */
    struct undo_list 
    {
        undo_list* next;
        int start, end;		/* Where the change took place. */
        char *text;			/* The text to insert, if undoing a delete. */
        undo_code what;		/* Delete, Insert, Begin, End. */
    }
    alias UNDO_LIST = undo_list;

    /* The current undo list for RL_LINE_BUFFER. */
    extern __gshared UNDO_LIST* rl_undo_list;

    /* The data structure for mapping textual names to code addresses. */
    struct _funmap 
    {
        const(char)* name;
        rl_command_func_t* function_;
    } 
    alias FUNMAP = _funmap;

    extern __gshared FUNMAP** funmap;


/* **************************************************************** */
/*								    */
/*	     Functions available to bind to key sequences	    */
/*								    */
/* **************************************************************** */

    /* Bindable commands for numeric arguments. */
    int rl_digit_argument(int, int);
    int rl_universal_argument(int, int);

    /* Bindable commands for moving the cursor. */
    int rl_forward_byte(int, int);
    int rl_forward_char(int, int);
    int rl_forward(int, int);
    int rl_backward_byte(int, int);
    int rl_backward_char(int, int);
    int rl_backward(int, int);
    int rl_beg_of_line(int, int);
    int rl_end_of_line(int, int);
    int rl_forward_word(int, int);
    int rl_backward_word(int, int);
    int rl_refresh_line(int, int);
    int rl_clear_screen(int, int);
    int rl_skip_csi_sequence(int, int);
    int rl_arrow_keys(int, int);

    /* Bindable commands for inserting and deleting text. */
    int rl_insert(int, int);
    int rl_quoted_insert(int, int);
    int rl_tab_insert(int, int);
    int rl_newline(int, int);
    int rl_do_lowercase_version(int, int);
    int rl_rubout(int, int);
    int rl_delete(int, int);
    int rl_rubout_or_delete(int, int);
    int rl_delete_horizontal_space(int, int);
    int rl_delete_or_show_completions(int, int);
    int rl_insert_comment(int, int);

    /* Bindable commands for changing case. */
    int rl_upcase_word(int, int);
    int rl_downcase_word(int, int);
    int rl_capitalize_word(int, int);

    /* Bindable commands for transposing characters and words. */
    int rl_transpose_words(int, int);
    int rl_transpose_chars(int, int);

    /* Bindable commands for searching within a line. */
    int rl_char_search(int, int);
    int rl_backward_char_search(int, int);

    /* Bindable commands for readline's interface to the command history. */
    int rl_beginning_of_history(int, int);
    int rl_end_of_history(int, int);
    int rl_get_next_history(int, int);
    int rl_get_previous_history(int, int);

    /* Bindable commands for managing the mark and region. */
    int rl_set_mark(int, int);
    int rl_exchange_point_and_mark(int, int);

    /* Bindable commands to set the editing mode (emacs or vi). */
    int rl_vi_editing_mode(int, int);
    int rl_emacs_editing_mode(int, int);

    /* Bindable commands to change the insert mode (insert or overwrite) */
    int rl_overwrite_mode(int, int);

    /* Bindable commands for managing key bindings. */
    int rl_re_read_init_file(int, int);
    int rl_dump_functions(int, int);
    int rl_dump_macros(int, int);
    int rl_dump_variables(int, int);

    /* Bindable commands for word completion. */
    int rl_complete(int, int);
    int rl_possible_completions(int, int);
    int rl_insert_completions(int, int);
    int rl_old_menu_complete(int, int);
    int rl_menu_complete(int, int);
    int rl_backward_menu_complete(int, int);

    /* Bindable commands for killing and yanking text, and managing the kill ring. */
    int rl_kill_word(int, int);
    int rl_backward_kill_word(int, int);
    int rl_kill_line(int, int);
    int rl_backward_kill_line(int, int);
    int rl_kill_full_line(int, int);
    int rl_unix_word_rubout(int, int);
    int rl_unix_filename_rubout(int, int);
    int rl_unix_line_discard(int, int);
    int rl_copy_region_to_kill(int, int);
    int rl_kill_region(int, int);
    int rl_copy_forward_word(int, int);
    int rl_copy_backward_word(int, int);
    int rl_yank(int, int);
    int rl_yank_pop(int, int);
    int rl_yank_nth_arg(int, int);
    int rl_yank_last_arg(int, int);

    /* Bindable commands for incremental searching. */
    int rl_reverse_search_history(int, int);
    int rl_forward_search_history(int, int);

    /* Bindable keyboard macro commands. */
    int rl_start_kbd_macro(int, int);
    int rl_end_kbd_macro(int, int);
    int rl_call_last_kbd_macro(int, int);
    int rl_print_last_kbd_macro(int, int);

    /* Bindable undo commands. */
    int rl_revert_line(int, int);
    int rl_undo_command(int, int);

    /* Bindable tilde expansion commands. */
    int rl_tilde_expand(int, int);

    /* Bindable terminal control commands. */
    int rl_restart_output(int, int);
    int rl_stop_output(int, int);

    /* Miscellaneous bindable commands. */
    int rl_abort(int, int);
    int rl_tty_status(int, int);

    /* Bindable commands for incremental and non-incremental history searching. */
    int rl_history_search_forward(int, int);
    int rl_history_search_backward(int, int);
    int rl_history_substr_search_forward(int, int);
    int rl_history_substr_search_backward(int, int);
    int rl_noninc_forward_search(int, int);
    int rl_noninc_reverse_search(int, int);
    int rl_noninc_forward_search_again(int, int);
    int rl_noninc_reverse_search_again(int, int);

    /* Bindable command used when inserting a matching close character. */
    int rl_insert_close(int, int);

    /* Not available unless READLINE_CALLBACKS is defined. */
    void rl_callback_handler_install(const(char)*, rl_vcpfunc_t*);
    void rl_callback_read_char();
    void rl_callback_handler_remove();

    /* Things for vi mode. Not available unless readline is compiled -DVI_MODE. */
    /* VI-mode bindable commands. */
    int rl_vi_redo(int, int);
    int rl_vi_undo(int, int);
    int rl_vi_yank_arg(int, int);
    int rl_vi_fetch_history(int, int);
    int rl_vi_search_again(int, int);
    int rl_vi_search(int, int);
    int rl_vi_complete(int, int);
    int rl_vi_tilde_expand(int, int);
    int rl_vi_prev_word(int, int);
    int rl_vi_next_word(int, int);
    int rl_vi_end_word(int, int);
    int rl_vi_insert_beg(int, int);
    int rl_vi_append_mode(int, int);
    int rl_vi_append_eol(int, int);
    int rl_vi_eof_maybe(int, int);
    int rl_vi_insertion_mode(int, int);
    int rl_vi_insert_mode(int, int);
    int rl_vi_movement_mode(int, int);
    int rl_vi_arg_digit(int, int);
    int rl_vi_change_case(int, int);
    int rl_vi_put(int, int);
    int rl_vi_column(int, int);
    int rl_vi_delete_to(int, int);
    int rl_vi_change_to(int, int);
    int rl_vi_yank_to(int, int);
    int rl_vi_rubout(int, int);
    int rl_vi_delete(int, int);
    int rl_vi_back_to_indent(int, int);
    int rl_vi_first_print(int, int);
    int rl_vi_char_search(int, int);
    int rl_vi_match(int, int);
    int rl_vi_change_char(int, int);
    int rl_vi_subst(int, int);
    int rl_vi_overstrike(int, int);
    int rl_vi_overstrike_delete(int, int);
    int rl_vi_replace(int, int);
    int rl_vi_set_mark(int, int);
    int rl_vi_goto_mark(int, int);

    /* VI-mode utility functions. */
    int rl_vi_check();
    int rl_vi_domove(int, int*);
    int rl_vi_bracktype(int);

    void rl_vi_start_inserting(int, int, int);

    /* VI-mode pseudo-bindable commands, used as utility functions. */
    int rl_vi_fWord(int, int);
    int rl_vi_bWord(int, int);
    int rl_vi_eWord(int, int);
    int rl_vi_fword(int, int);
    int rl_vi_bword(int, int);
    int rl_vi_eword(int, int);


/* **************************************************************** */
/*								    */
/*			Well Published Functions		    */
/*								    */
/* **************************************************************** */

    /* Readline functions. */
    /* Read a line of input.  Prompt with PROMPT.  A NULL PROMPT means none. */
    char* readline(const(char)*);

    int rl_set_prompt(const(char)*);
    int rl_expand_prompt(char *);

    int rl_initialize ();

    /* Undocumented; unused by readline */
    int rl_discard_argument();

    /* Utility functions to bind keys to readline commands. */
    int rl_add_defun (const(char)*, rl_command_func_t *, int);
    int rl_bind_key (int, rl_command_func_t *);
    int rl_bind_key_in_map (int, rl_command_func_t *, Keymap);
    int rl_unbind_key (int);
    int rl_unbind_key_in_map (int, Keymap);
    int rl_bind_key_if_unbound (int, rl_command_func_t *);
    int rl_bind_key_if_unbound_in_map (int, rl_command_func_t *, Keymap);
    int rl_unbind_function_in_map (rl_command_func_t *, Keymap);
    int rl_unbind_command_in_map (const(char)*, Keymap);
    int rl_bind_keyseq (const(char)**, rl_command_func_t *);
    int rl_bind_keyseq_in_map (const(char)**, rl_command_func_t *, Keymap);
    int rl_bind_keyseq_if_unbound (const(char)**, rl_command_func_t *);
    int rl_bind_keyseq_if_unbound_in_map (const(char)**, rl_command_func_t *, Keymap);
    int rl_generic_bind (int, const(char)**, char *, Keymap);

    char *rl_variable_value (const(char)**);
    int rl_variable_bind (const(char)**, const(char)**);

    /* Backwards compatibility, use rl_bind_keyseq_in_map instead. */
    int rl_set_key (const(char)**, rl_command_func_t *, Keymap);

    /* Backwards compatibility, use rl_generic_bind instead. */
    int rl_macro_bind (const(char)**, const(char)**, Keymap);

    /* Undocumented in the texinfo manual; not really useful to programs. */
    int rl_translate_keyseq (const(char)**, char *, int *);
    char *rl_untranslate_keyseq (int);

    rl_command_func_t *rl_named_function (const(char)**);
    rl_command_func_t *rl_function_of_keyseq (const(char)**, Keymap, int *);

    void rl_list_funmap_names ();
    char **rl_invoking_keyseqs_in_map (rl_command_func_t *, Keymap);
    char **rl_invoking_keyseqs (rl_command_func_t *);
     
    void rl_function_dumper (int);
    void rl_macro_dumper (int);
    void rl_variable_dumper (int);

    int rl_read_init_file (const(char)**);
    int rl_parse_and_bind (char *);

    /* Functions for manipulating keymaps. */
    Keymap rl_make_bare_keymap ();
    Keymap rl_copy_keymap (Keymap);
    Keymap rl_make_keymap ();
    void rl_discard_keymap (Keymap);
    void rl_free_keymap (Keymap);

    Keymap rl_get_keymap_by_name (const(char)**);
    char *rl_get_keymap_name (Keymap);
    void rl_set_keymap (Keymap);
    Keymap rl_get_keymap ();
    /* Undocumented; used internally only. */
    void rl_set_keymap_from_edit_mode ();
    char *rl_get_keymap_name_from_edit_mode ();

    /* Functions for manipulating the funmap, which maps command names to functions. */
    int rl_add_funmap_entry (const(char)**, rl_command_func_t *);
    const(char)***rl_funmap_names ();
    /* Undocumented, only used internally -- there is only one funmap, and this
       function may be called only once. */
    void rl_initialize_funmap ();

    /* Utility functions for managing keyboard macros. */
    void rl_push_macro_input (char *);

    /* Functions for undoing, from undo.c */
    void rl_add_undo (undo_code, int, int, char *);
    void rl_free_undo_list ();
    int rl_do_undo ();
    int rl_begin_undo_group ();
    int rl_end_undo_group ();
    int rl_modifying (int, int);

    /* Functions for redisplay. */
    void rl_redisplay ();
    int rl_on_new_line ();
    int rl_on_new_line_with_prompt ();
    int rl_forced_update_display ();
    int rl_clear_message ();
    int rl_reset_line_state ();
    int rl_crlf ();

    //int rl_message (const(char)**, ...)  __rl_attribute__((__format__ (printf, 1, 2));

    int rl_show_char (int);

    /* Undocumented in texinfo manual. */
    int rl_character_len (int, int);

    /* Save and restore internal prompt redisplay information. */
    void rl_save_prompt ();
    void rl_restore_prompt ();

    /* Modifying text. */
    void rl_replace_line (const(char)**, int);
    int rl_insert_text (const(char)**);
    int rl_delete_text (int, int);
    int rl_kill_text (int, int);
    char *rl_copy_text (int, int);

    /* Terminal and tty mode management. */
    void rl_prep_terminal (int);
    void rl_deprep_terminal ();
    void rl_tty_set_default_bindings (Keymap);
    void rl_tty_unset_default_bindings (Keymap);

    int rl_reset_terminal (const(char)**);
    void rl_resize_terminal ();
    void rl_set_screen_size (int, int);
    void rl_get_screen_size (int *, int *);
    void rl_reset_screen_size ();

    char *rl_get_termcap (const(char)**);

    /* Functions for character input. */
    int rl_stuff_char (int);
    int rl_execute_next (int);
    int rl_clear_pending_input ();
    int rl_read_key ();
    int rl_getc (FILE *);
    int rl_set_keyboard_input_timeout (int);

    /* `Public' utility functions . */
    void rl_extend_line_buffer (int);
    int rl_ding ();
    int rl_alphabetic (int);
    void rl_free (void *);

    /* Readline signal handling, from signals.c */
    int rl_set_signals ();
    int rl_clear_signals ();
    void rl_cleanup_after_signal ();
    void rl_reset_after_signal ();
    void rl_free_line_state ();

    void rl_echo_signal_char (int); 

    int rl_set_paren_blink_timeout (int);

    /* History management functions. */

    void rl_clear_history ();

    /* Undocumented. */
    int rl_maybe_save_line ();
    int rl_maybe_unsave_line ();
    int rl_maybe_replace_line ();

    /* Completion functions. */
    int rl_complete_internal (int);
    void rl_display_match_list (char **, int, int);

    char **rl_completion_matches (const(char)**, rl_compentry_func_t *);
    char *rl_username_completion_function (const(char)**, int);
    char *rl_filename_completion_function (const(char)**, int);

    int rl_completion_mode (rl_command_func_t *);


/* **************************************************************** */
/*								    */
/*			Well Published Variables		    */
/*								    */
/* **************************************************************** */

/* The version of this incarnation of the readline library. */
extern __gshared const(char)* rl_library_version;		/* e.g., "4.2" */
extern __gshared int rl_readline_version;			/* e.g., 0x0402 */

/* True if this is real GNU readline. */
extern __gshared int rl_gnu_readline_p;

/* Flags word encapsulating the current readline state. */
extern __gshared int rl_readline_state;

/* Says which editing mode readline is currently using.  1 means emacs mode;
   0 means vi mode. */
extern __gshared int rl_editing_mode;

/* Insert or overwrite mode for emacs mode.  1 means insert mode; 0 means
   overwrite mode.  Reset to insert mode on each input line. */
extern __gshared int rl_insert_mode;

/* The name of the calling program.  You should initialize this to
   whatever was in argv[0].  It is used when parsing conditionals. */
extern __gshared const(char)* rl_readline_name;

/* The prompt readline uses.  This is set from the argument to
   readline (), and should not be assigned to directly. */
extern __gshared char *rl_prompt;

/* The prompt string that is actually displayed by rl_redisplay.  Public so
   applications can more easily supply their own redisplay functions. */
extern __gshared char *rl_display_prompt;

/* The line buffer that is in use. */
extern __gshared char *rl_line_buffer;

/* The location of point, and end. */
extern __gshared int rl_point;
extern __gshared int rl_end;

/* The mark, or saved cursor position. */
extern __gshared int rl_mark;

/* Flag to indicate that readline has finished with the current input
   line and should return it. */
extern __gshared int rl_done;

/* If set to a character value, that will be the next keystroke read. */
extern __gshared int rl_pending_input;

/* Non-zero if we called this function from _rl_dispatch().  It's present
   so functions can find out whether they were called from a key binding
   or directly from an application. */
extern __gshared int rl_dispatching;

/* Non-zero if the user typed a numeric argument before executing the
   current function. */
extern __gshared int rl_explicit_arg;

/* The current value of the numeric argument specified by the user. */
extern __gshared int rl_numeric_arg;

/* The address of the last command function Readline executed. */
extern __gshared rl_command_func_t *rl_last_func;

/* The name of the terminal to use. */
extern __gshared const(char)* rl_terminal_name;

/* The input and output streams. */
extern __gshared FILE *rl_instream;
extern __gshared FILE *rl_outstream;

/* If non-zero, Readline gives values of LINES and COLUMNS from the environment
   greater precedence than values fetched from the kernel when computing the
   screen dimensions. */
extern __gshared int rl_prefer_env_winsize;

/* If non-zero, then this is the address of a function to call just
   before readline_internal () prints the first prompt. */
extern __gshared rl_hook_func_t *rl_startup_hook;

/* If non-zero, this is the address of a function to call just before
   readline_internal_setup () returns and readline_internal starts
   reading input characters. */
extern __gshared rl_hook_func_t *rl_pre_input_hook;
      
/* The address of a function to call periodically while Readline is
   awaiting character input, or NULL, for no event handling. */
extern __gshared rl_hook_func_t *rl_event_hook;

/* The address of a function to call if a read is interrupted by a signal. */
extern __gshared rl_hook_func_t *rl_signal_event_hook;

/* The address of a function to call if Readline needs to know whether or not
   there is data available from the current input source. */
extern __gshared rl_hook_func_t *rl_input_available_hook;

/* The address of the function to call to fetch a character from the current
   Readline input stream */
extern __gshared rl_getc_func_t *rl_getc_function;

extern __gshared rl_voidfunc_t *rl_redisplay_function;

extern __gshared rl_vintfunc_t *rl_prep_term_function;
extern __gshared rl_voidfunc_t *rl_deprep_term_function;

/* Dispatch variables. */
extern __gshared Keymap rl_executing_keymap;
extern __gshared Keymap rl_binding_keymap;

extern __gshared int rl_executing_key;
extern __gshared char *rl_executing_keyseq;
extern __gshared int rl_key_sequence_length;

/* Display variables. */
/* If non-zero, readline will erase the entire line, including any prompt,
   if the only thing typed on an otherwise-blank line is something bound to
   rl_newline. */
extern __gshared int rl_erase_empty_line;

/* If non-zero, the application has already printed the prompt (rl_prompt)
   before calling readline, so readline should not output it the first time
   redisplay is done. */
extern __gshared int rl_already_prompted;

/* A non-zero value means to read only this many characters rather than
   up to a character bound to accept-line. */
extern __gshared int rl_num_chars_to_read;

/* The text of a currently-executing keyboard macro. */
extern __gshared char *rl_executing_macro;

/* Variables to control readline signal handling. */
/* If non-zero, readline will install its own signal handlers for
   SIGINT, SIGTERM, SIGQUIT, SIGALRM, SIGTSTP, SIGTTIN, and SIGTTOU. */
extern __gshared int rl_catch_signals;

/* If non-zero, readline will install a signal handler for SIGWINCH
   that also attempts to call any calling application's SIGWINCH signal
   handler.  Note that the terminal is not cleaned up before the
   application's signal handler is called; use rl_cleanup_after_signal()
   to do that. */
extern __gshared int rl_catch_sigwinch;

/* If non-zero, the readline SIGWINCH handler will modify LINES and
   COLUMNS in the environment. */
extern __gshared int rl_change_environment;

/* Completion variables. */
/* Pointer to the generator function for completion_matches ().
   NULL means to use rl_filename_completion_function (), the default
   filename completer. */
extern __gshared rl_compentry_func_t *rl_completion_entry_function;

/* Optional generator for menu completion.  Default is
   rl_completion_entry_function (rl_filename_completion_function). */
 extern __gshared rl_compentry_func_t *rl_menu_completion_entry_function;

/* If rl_ignore_some_completions_function is non-NULL it is the address
   of a function to call after all of the possible matches have been
   generated, but before the actual completion is done to the input line.
   The function is called with one argument; a NULL terminated array
   of (char *).  If your function removes any of the elements, they
   must be free()'ed. */
extern __gshared rl_compignore_func_t *rl_ignore_some_completions_function;

/* Pointer to alternative function to create matches.
   Function is called with TEXT, START, and END.
   START and END are indices in RL_LINE_BUFFER saying what the boundaries
   of TEXT are.
   If this function exists and returns NULL then call the value of
   rl_completion_entry_function to try to match, otherwise use the
   array of strings returned. */
extern __gshared rl_completion_func_t *rl_attempted_completion_function;

/* The basic list of characters that signal a break between words for the
   completer routine.  The initial contents of this variable is what
   breaks words in the shell, i.e. "n\"\\'`@$>". */
extern __gshared const(char)* rl_basic_word_break_characters;

/* The list of characters that signal a break between words for
   rl_complete_internal.  The default list is the contents of
   rl_basic_word_break_characters.  */
extern __gshared /*const*/ char *rl_completer_word_break_characters;

/* Hook function to allow an application to set the completion word
   break characters before readline breaks up the line.  Allows
   position-dependent word break characters. */
extern __gshared rl_cpvfunc_t *rl_completion_word_break_hook;

/* List of characters which can be used to quote a substring of the line.
   Completion occurs on the entire substring, and within the substring   
   rl_completer_word_break_characters are treated as any other character,
   unless they also appear within this list. */
extern __gshared const(char)* rl_completer_quote_characters;

/* List of quote characters which cause a word break. */
extern __gshared const(char)* rl_basic_quote_characters;

/* List of characters that need to be quoted in filenames by the completer. */
extern __gshared const(char)* rl_filename_quote_characters;

/* List of characters that are word break characters, but should be left
   in TEXT when it is passed to the completion function.  The shell uses
   this to help determine what kind of completing to do. */
extern __gshared const(char)* rl_special_prefixes;

/* If non-zero, then this is the address of a function to call when
   completing on a directory name.  The function is called with
   the address of a string (the current directory name) as an arg.  It
   changes what is displayed when the possible completions are printed
   or inserted.  The directory completion hook should perform
   any necessary dequoting.  This function should return 1 if it modifies
   the directory name pointer passed as an argument.  If the directory
   completion hook returns 0, it should not modify the directory name
   pointer passed as an argument. */
extern __gshared rl_icppfunc_t *rl_directory_completion_hook;

/* If non-zero, this is the address of a function to call when completing
   a directory name.  This function takes the address of the directory name
   to be modified as an argument.  Unlike rl_directory_completion_hook, it
   only modifies the directory name used in opendir(2), not what is displayed
   when the possible completions are printed or inserted.  If set, it takes
   precedence over rl_directory_completion_hook.  The directory rewrite
   hook should perform any necessary dequoting.  This function has the same
   return value properties as the directory_completion_hook.

   I'm not happy with how this works yet, so it's undocumented.  I'm trying
   it in bash to see how well it goes. */
extern __gshared rl_icppfunc_t *rl_directory_rewrite_hook;

/* If non-zero, this is the address of a function for the completer to call
   before deciding which character to append to a completed name.  It should
   modify the directory name passed as an argument if appropriate, and return
   non-zero if it modifies the name.  This should not worry about dequoting
   the filename; that has already happened by the time it gets here. */
extern __gshared rl_icppfunc_t *rl_filename_stat_hook;

/* If non-zero, this is the address of a function to call when reading
   directory entries from the filesystem for completion and comparing
   them to the partial word to be completed.  The function should
   either return its first argument (if no conversion takes place) or
   newly-allocated memory.  This can, for instance, convert filenames
   between character sets for comparison against what's typed at the
   keyboard.  The returned value is what is added to the list of
   matches.  The second argument is the length of the filename to be
   converted. */
extern __gshared rl_dequote_func_t *rl_filename_rewrite_hook;

/* Backwards compatibility with previous versions of readline. */
alias rl_symbolic_link_hook  = rl_directory_completion_hook;

/* If non-zero, then this is the address of a function to call when
   completing a word would normally display the list of possible matches.
   This function is called instead of actually doing the display.
   It takes three arguments: (char **matches, int num_matches, int max_length)
   where MATCHES is the array of strings that matched, NUM_MATCHES is the
   number of strings in that array, and MAX_LENGTH is the length of the
   longest string in that array. */
extern __gshared rl_compdisp_func_t *rl_completion_display_matches_hook;

/* Non-zero means that the results of the matches are to be treated
   as filenames.  This is ALWAYS zero on entry, and can only be changed
   within a completion entry finder function. */
extern __gshared int rl_filename_completion_desired;

/* Non-zero means that the results of the matches are to be quoted using
   double quotes (or an application-specific quoting mechanism) if the
   filename contains any characters in rl_word_break_chars.  This is
   ALWAYS non-zero on entry, and can only be changed within a completion
   entry finder function. */
extern __gshared int rl_filename_quoting_desired;

/* Set to a function to quote a filename in an application-specific fashion.
   Called with the text to quote, the type of match found (single or multiple)
   and a pointer to the quoting character to be used, which the function can
   reset if desired. */
extern __gshared rl_quote_func_t *rl_filename_quoting_function;

/* Function to call to remove quoting characters from a filename.  Called
   before completion is attempted, so the embedded quotes do not interfere
   with matching names in the file system. */
extern __gshared rl_dequote_func_t *rl_filename_dequoting_function;

/* Function to call to decide whether or not a word break character is
   quoted.  If a character is quoted, it does not break words for the
   completer. */
extern __gshared rl_linebuf_func_t *rl_char_is_quoted_p;

/* Non-zero means to suppress normal filename completion after the
   user-specified completion function has been called. */
extern __gshared int rl_attempted_completion_over;

/* Set to a character describing the type of completion being attempted by
   rl_complete_internal; available for use by application completion
   functions. */
extern __gshared int rl_completion_type;

/* Set to the last key used to invoke one of the completion functions */
extern __gshared int rl_completion_invoking_key;

/* Up to this many items will be displayed in response to a
   possible-completions call.  After that, we ask the user if she
   is sure she wants to see them all.  The default value is 100. */
extern __gshared int rl_completion_query_items;

/* Character appended to completed words when at the end of the line.  The
   default is a space.  Nothing is added if this is '\0'. */
extern __gshared int rl_completion_append_character;

/* If set to non-zero by an application completion function,
   rl_completion_append_character will not be appended. */
extern __gshared int rl_completion_suppress_append;

/* Set to any quote character readline thinks it finds before any application
   completion function is called. */
extern __gshared int rl_completion_quote_character;

/* Set to a non-zero value if readline found quoting anywhere in the word to
   be completed; set before any application completion function is called. */
extern __gshared int rl_completion_found_quote;

/* If non-zero, the completion functions don't append any closing quote.
   This is set to 0 by rl_complete_internal and may be changed by an
   application-specific completion function. */
extern __gshared int rl_completion_suppress_quote;

/* If non-zero, readline will sort the completion matches.  On by default. */
extern __gshared int rl_sort_completion_matches;

/* If non-zero, a slash will be appended to completed filenames that are
   symbolic links to directory names, subject to the value of the
   mark-directories variable (which is user-settable).  This exists so
   that application completion functions can override the user's preference
   (set via the mark-symlinked-directories variable) if appropriate.
   It's set to the value of _rl_complete_mark_symlink_dirs in
   rl_complete_internal before any application-specific completion
   function is called, so without that function doing anything, the user's
   preferences are honored. */
extern __gshared int rl_completion_mark_symlink_dirs;

/* If non-zero, then disallow duplicates in the matches. */
extern __gshared int rl_ignore_completion_duplicates;

/* If this is non-zero, completion is (temporarily) inhibited, and the
   completion character will be inserted as any other. */
extern __gshared int rl_inhibit_completion;

/* Input error; can be returned by (*rl_getc_function) if readline is reading
   a top-level command (RL_ISSTATE (RL_STATE_READCMD)). */
enum READERR = -2;

/* Definitions available for use by readline clients. */
enum RL_PROMPT_START_IGNORE	= '\001';
enum RL_PROMPT_END_IGNORE	= '\002';

/* Possible values for do_replace argument to rl_filename_quoting_function,
   called by rl_complete_internal. */
enum NO_MATCH = 0;
enum SINGLE_MATCH = 1;
enum MULT_MATCH = 2;

/* Possible state values for rl_readline_state */
enum RL_STATE_NONE = 0x000000;		/* no state; before first call */
enum RL_STATE_INITIALIZING	= 0x0000001;	/* initializing */
enum RL_STATE_INITIALIZED	= 0x0000002	;/* initialization done */
enum RL_STATE_TERMPREPPED	= 0x0000004	;/* terminal is prepped */
enum RL_STATE_READCMD	    = 0x0000008	;/* reading a command key */
enum RL_STATE_METANEXT	    = 0x0000010	;/* reading input after ESC */
enum RL_STATE_DISPATCHING	= 0x0000020	;/* dispatching to a command */
enum RL_STATE_MOREINPUT	    = 0x0000040	;/* reading more input in a command function */
enum RL_STATE_ISEARCH	    = 0x0000080	;/* doing incremental search */
enum RL_STATE_NSEARCH	    = 0x0000100	;/* doing non-inc search */
enum RL_STATE_SEARCH		    = 0x0000200	;/* doing a history search */
enum RL_STATE_NUMERICARG	    = 0x0000400	;/* reading numeric argument */
enum RL_STATE_MACROINPUT	    = 0x0000800	;/* getting input from a macro */
enum RL_STATE_MACRODEF	    = 0x0001000	;/* defining keyboard macro */
enum RL_STATE_OVERWRITE	    = 0x0002000	;/* overwrite mode */
enum RL_STATE_COMPLETING	    = 0x0004000	;/* doing completion */
enum RL_STATE_SIGHANDLER	    = 0x0008000	;/* in readline sighandler */
enum RL_STATE_UNDOING	    = 0x0010000	;/* doing an undo */
enum RL_STATE_INPUTPENDING	= 0x0020000	;/* rl_execute_next called */
enum RL_STATE_TTYCSAVED	    = 0x0040000	;/* tty special chars saved */
enum RL_STATE_CALLBACK	    = 0x0080000	;/* using the callback interface */
enum RL_STATE_VIMOTION	    = 0x0100000	;/* reading vi motion arg */
enum RL_STATE_MULTIKEY	    = 0x0200000	;/* reading multiple-key command */
enum RL_STATE_VICMDONCE	    = 0x0400000	;/* entered vi command mode at least once */
enum RL_STATE_REDISPLAYING	= 0x0800000	;/* updating terminal display */

enum RL_STATE_DONE		= 0x1000000	;/* done; accepted line */

int RL_SETSTATE(int x)
{
    return rl_readline_state |= x;
}

int RL_UNSETSTATE(int x)
{
    return rl_readline_state &= ~x; 
}

auto RL_ISSTATE(int x)
{
    return rl_readline_state & x; 
}

struct readline_state 
{
  /* line state */
  int point;
  int end;
  int mark;
  char *buffer;
  int buflen;
  UNDO_LIST *ul;
  char *prompt;

  /* global state */
  int rlstate;
  int done;
  Keymap kmap;

  /* input state */
  rl_command_func_t *lastfunc;
  int insmode;
  int edmode;
  int kseqlen;
  FILE *inf;
  FILE *outf;
  int pendingin;
  char *macro_;

  /* signal state */
  int catchsigs;
  int catchsigwinch;

  /* search state */

  /* completion state */

  /* options state */

  /* reserved for future expansion, so the struct size doesn't change */
  char[64] reserved;
}

int rl_save_state(readline_state *);
int rl_restore_state(readline_state *);

}
