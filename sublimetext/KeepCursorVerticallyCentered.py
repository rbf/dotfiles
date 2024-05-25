# Done by rbf, 25may2024

import sublime_plugin

# Intended to be used in Distraction free mode by adding
# `'keep_cursor_vertically_centered': true` to the file
# [usual path]/Packages/User/Distraction Free.sublime-settings

class KeepCursorVerticallyCenteredCommand(sublime_plugin.EventListener):
    # SOURCE: https://stackoverflow.com/a/47786967
    # SOURCE: https://forum.sublimetext.com/t/always-centered-cursor/4005/2
    # SOURCE: https://forum.sublimetext.com/t/always-centered-cursor/4005/3
    # def on_modified(self, view):
    def on_selection_modified(self, view):
        if view.settings().get('keep_cursor_vertically_centered'):
            print("yay")
            sel = view.sel()
            pt = sel[0].begin() if len(sel) == 1 else None
            if pt != None:
                view.show_at_center(pt)
