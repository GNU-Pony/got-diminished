PREFIX = /usr
LIBEXEC = /libexec
SYSCONF = /etc
PKGNAME = got-diminished
DATA = /share
LICENSES = $(PREFIX)$(DATA)/licenses

OPTIMISE = -Os

BINS = login ssh cerberus
_BINS = $(foreach B, $(BINS), bin/got-diminished-$(B))

# Use /sbin for LIBEXEC if you do not have /libexec in PREFIX



.PHONY: all
all: got-diminished $(_BINS)


got-diminished: src/got-diminished
	cp "$<" "$@"
	sed -i "s:/usr/libexec/:$(PREFIX)$(LIBEXEC)/:g" "$@"


bin/%: src/%.c
	@mkdir -p bin
	gcc $(OPTIMISE) -o "$@" "$<"


.PHONY: install
install: got-diminished $(_BINS)
	install -d     --                          "$(DESTDIR)$(SYSCONF)/gotrc.examples"
	install  -m644 -- got-diminished           "$(DESTDIR)$(SYSCONF)/gotrc.examples"
	install -d     --                          "$(DESTDIR)$(PREFIX)$(LIBEXEC)"
	install  -m755 -- $(_BINS)                 "$(DESTDIR)$(PREFIX)$(LIBEXEC)"
	install -d     --                          "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	install  -m644 -- COPYING LICENSE          "$(DESTDIR)$(LICENSES)/$(PKGNAME)"


.PHONY: uninstall
uninstall:
	-rm    -- $(foreach B, $(BINS), "$(DESTDIR)$(PREFIX)$(LIBEXEC)/got-diminished-$(B)")
	-rm    -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/COPYING"
	-rm    -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/LICENSE"
	-rm -d -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"


.PHONY: clean
clean:
	-rm -r bin got-diminished

