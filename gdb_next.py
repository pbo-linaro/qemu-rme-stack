import gdb
import time

def current_symbol():
    try:
        name = gdb.selected_frame().name
        if name is None:
            return ''
        else:
            return name()
    except:
            return ''

def current_binary():
    try:
        return gdb.selected_frame().find_sal().symtab.objfile.filename
    except:
        return ''

def current_source():
    try:
        return gdb.selected_frame().find_sal().symtab.fullname()
    except:
        return ''

def current_line():
    try:
        return gdb.selected_frame().find_sal().line
    except:
        return ''

def current_location():
    return current_source() + ':' + str(current_line())

def step_instruction_until_state_change(state_name, get_state):
    from_state = get_state()
    from_symbol = current_symbol()
    from_location = current_location()
    from_source = current_source()
    last_symbol = from_symbol
    last_location = from_location
    while True:
        gdb.execute("stepi")
        new_state = get_state()
        if new_state and new_state != from_state:
            print('from_{}: {}'.format(state_name, from_state))
            print('to_{}: {}'.format(state_name, new_state))
            print('from: {} @ {}'.format(from_symbol, from_location))
            print('last: {} @ {}'.format(last_symbol, last_location))
            print('to: {} @ {}'.format(current_symbol(), current_location()))
            return 
        last_symbol = current_symbol()
        last_location = current_location()

# Single step until we reach a new object file
class next_binary(gdb.Command):
    def __init__(self):
        super(next_binary, self).__init__("next-binary", gdb.COMMAND_USER)

    def invoke(self, argument, fromtty):
        step_instruction_until_state_change('binary', current_binary)

# Single step until we reach a new source file
class next_source(gdb.Command):
    def __init__(self):
        super(next_source, self).__init__("next-source", gdb.COMMAND_USER)

    def invoke(self, argument, fromtty):
        step_instruction_until_state_change('source', current_source)

next_binary()
next_source()
