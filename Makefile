PREFIX = /usr
LIBEXEC = /libexec
SYSCONF = /etc
PKGNAME = got-diminished

OPTIMISE = -Os

# Use /sbin for LIBEXEC if you do not have /libexec in PREFIX



.PHONY: all
all: got-diminished bin/got-diminished-login bin/got-diminished-ssh


got-diminished: src/got-diminished
	cp "$<" "$@"
	sed -i "s:/usr/libexec/:$(PREFIX)$(LIBEXEC)/:g" "$@"


bin/%: src/%.c
	@mkdir -p bin
	gcc $(OPTIMISE) -o "$@" "$<"


.PHONY: install
install: got-diminished bin/got-diminished-login bin/got-diminished-ssh
	install -d     --                          "$(DESTDIR)$(SYSCONF)/gotrc.examples"
	install  -m644 -- got-diminished           "$(DESTDIR)$(SYSCONF)/gotrc.examples"
	install -d     --                          "$(DESTDIR)$(PREFIX)$(LIBEXEC)"
	install  -m755 -- bin/got-diminished-login "$(DESTDIR)$(PREFIX)$(LIBEXEC)"
	install  -m755 -- bin/got-diminished-ssh   "$(DESTDIR)$(PREFIX)$(LIBEXEC)"
	install -d     --                          "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	install  -m644 -- COPYING LICENSE          "$(DESTDIR)$(LICENSES)/$(PKGNAME)"


.PHONY: uninstall
uninstall:
	-rm    -- "$(DESTDIR)$(PREFIX)$(LIBEXEC)/got-diminished-login"
	-rm    -- "$(DESTDIR)$(PREFIX)$(LIBEXEC)/got-diminished-ssh"
	-rm    -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/COPYING"
	-rm    -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/LICENSE"
	-rm -d -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"


.PHONY: clean
clean:
	-rm -r bin

