PREFIX = /usr
LIBEXEC = /libexec
SYSCONF = /etc
PKGNAME = got-diminished
DATA = /share
LICENSES = $(PREFIX)$(DATA)/licenses

OPTIMISE = -Os
WARN = -Wall -Wextra -pedantic -Wdouble-promotion -Wformat=2 -Winit-self -Wmissing-include-dirs \
       -Wfloat-equal -Wmissing-prototypes -Wmissing-declarations -Wtrampolines -Wnested-externs \
       -Wno-variadic-macros -Wdeclaration-after-statement -Wundef -Wpacked -Wunsafe-loop-optimizations \
       -Wbad-function-cast -Wwrite-strings -Wlogical-op -Wstrict-prototypes -Wold-style-definition \
       -Wvector-operation-performance -Wstack-protector -Wunsuffixed-float-constants -Wcast-align \
       -Wsync-nand -Wshadow -Wredundant-decls -Winline -Wcast-qual -Wsign-conversion -Wstrict-overflow

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
	gcc $(OPTIMISE) $(WARN) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o "$@" "$<"


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

