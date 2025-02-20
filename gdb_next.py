import gdb
import time

def step_instruction_until_state_change(get_state):
    from_state = get_state()
    while True:
        gdb.execute("stepi")
        new_state = get_state()
        if new_state and new_state != from_state:
            print('from: ' + from_state)
            print('to: ' + new_state)
            return 

# Single step until we reach a new object file
class next_binary(gdb.Command):
    def __init__(self):
        super(next_binary, self).__init__("next-binary", gdb.COMMAND_USER)

    def current_binary(self):
        try:
            return gdb.selected_frame().find_sal().symtab.objfile.filename
        except:
            return ''

    def invoke(self, argument, fromtty):
        step_instruction_until_state_change(self.current_binary)

# Single step until we reach a new source file
class next_source(gdb.Command):
    def __init__(self):
        super(next_source, self).__init__("next-source", gdb.COMMAND_USER)

    def current_source(self):
        try:
            return gdb.selected_frame().find_sal().symtab.fullname()
        except:
            return ''

    def invoke(self, argument, fromtty):
        step_instruction_until_state_change(self.current_source)

next_binary()
next_source()
