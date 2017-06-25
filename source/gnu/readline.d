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



}
