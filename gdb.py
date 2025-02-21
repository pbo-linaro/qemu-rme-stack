import gdb

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

def current_arm_exception_level():
    cpsr = gdb.selected_frame().read_register('cpsr')
    # returned value is a gdb.Value, which supports bitwise operation, but
    # rounds to another value, resulting in a wrong EL.
    cpsr = int(cpsr)
    # bits 3:2 is EL
    el = cpsr >> 2 & 0b11
    return el

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
        gdb.execute('stepi')
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
        super(next_binary, self).__init__('next-binary', gdb.COMMAND_USER)

    def invoke(self, argument, fromtty):
        step_instruction_until_state_change('binary', current_binary)

# Single step until we reach a new source file
class next_source(gdb.Command):
    def __init__(self):
        super(next_source, self).__init__('next-source', gdb.COMMAND_USER)

    def invoke(self, argument, fromtty):
        step_instruction_until_state_change('source', current_source)

# Single step until we reach a new source file
class next_arm_exception_level(gdb.Command):
    def __init__(self):
        super(next_arm_exception_level, self).__init__('next-arm-exception-level', gdb.COMMAND_USER)

    def invoke(self, argument, fromtty):
        step_instruction_until_state_change('EL', current_arm_exception_level)

# Print current exception level
class arm_exception_level(gdb.Command):
    def __init__ (self):
        super (arm_exception_level, self).__init__ ("arm-exception-level", gdb.COMMAND_USER)

    def invoke (self, arg, from_tty):
        print(current_arm_exception_level())

next_arm_exception_level()
arm_exception_level()
next_binary()
next_source()
