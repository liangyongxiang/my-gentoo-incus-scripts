#!/usr/bin/env python

import argparse
import shlex
import sys
import string

def makeconf_update(update_key, update_value, conf_file="/etc/portage/make.conf"):
    with open(conf_file, 'r+') as f:
        written = False
        lex = shlex.shlex(f, posix=True)
        lex.wordchars = string.digits + string.ascii_letters + r"~!@#$%*_\:;?,./-+{}"
        lex.quotes = "\"'"
        while True:
            key = lex.get_token()
            if key is None:
                break

            if key == update_key:
                begin_line = lex.lineno
                equ = lex.get_token()
                if equ is None:
                    break
                if equ != "=":
                    continue

                val = lex.get_token()
                if val is None:
                    break

                end_line = lex.lineno

                f.seek(0)
                lines = f.readlines()

                f.seek(0)
                for index, line in enumerate(lines):
                    if index < begin_line - 1 or index >= end_line - 1:
                        f.write(line)
                    elif not written:
                        written = True
                        f.write('%s="%s"\n' % (update_key, update_value))

                break
        if not written:
            f.write('%s="%s"\n' % (update_key, update_value))

        f.truncate()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("key", help="Key of VARIABLE in make.conf")
    parser.add_argument("value", help="Value of VARIABLE in make.conf")
    args = parser.parse_args()

    if args.key and args.value:
        makeconf_update(args.key, args.value)
    else:
        print("key:%s, value:%d: %s" % (args.key, args.value))
        sys.exit(1)

if __name__ == '__main__':
    main()
