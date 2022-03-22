cat phone-numbers  | tr '    ' '\n' | grep -wPc '^\+?[1-9][0-9]{1,14}$'
