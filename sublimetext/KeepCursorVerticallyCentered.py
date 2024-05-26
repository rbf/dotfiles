# Done by rbf, 25may2024

import sublime_plugin

# Intended to be used in Distraction free mode by adding
# `'keep_cursor_vertically_centered': true` to the file
# [usual path]/Packages/User/Distraction Free.sublime-settings

# SOURCE: https://stackoverflow.com/a/47786967
# SOURCE: https://forum.sublimetext.com/t/always-centered-cursor/4005/3

def center_cursor_vertically(view):
    sel = view.sel()
    if len(sel) == 1:
        # Use .b to keep the cursor centered when selecting lines with SHIFT and
        # the cursor keys.
        view.show_at_center(sel[0].b, animate = True)


class KeepCursorVerticallyCenteredCommand(sublime_plugin.EventListener):
    def __init__(self):
        self.allow_scroll_view = False

    def on_text_command(self, view, command_name, args):
        # Do not scroll the view if clicking with the mouse, i.e. when the
        # command "drag_select" is fired, as the behavior feels too erratic.
        self.allow_scroll_view = command_name != "drag_select"

    def on_modified(self, view):
        self.allow_scroll_view = True

    def on_selection_modified(self, view):
        if self.allow_scroll_view and view.settings().get('keep_cursor_vertically_centered'):
            center_cursor_vertically(view)


class KeepCursorVerticallyCenteredToggleForViewCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        settings = self.view.settings()
        new_value = not settings.get("keep_cursor_vertically_centered", False)
        settings.set("keep_cursor_vertically_centered", new_value)
        if new_value:
            center_cursor_vertically(self.view)


class KeepCursorVerticallyCenteredResetToViewDefaultCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        settings = self.view.settings()
        key_to_remove = "keep_cursor_vertically_centered"
        if key_to_remove in settings:
            del settings[key_to_remove]
        if settings.get(key_to_remove, False):
            center_cursor_vertically(self.view)
