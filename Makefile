PREFIX = /usr
LIBEXEC = /libexec
SYSCONF = /etc
PKGNAME = got-diminished
DATA = /share
LICENSES = $(PREFIX)$(DATA)/licenses

OPTIMISE = -Os
WARN = -Wall -Wextra -pedantic -Wdouble-promotion -Wformat=2 -Winit-self -Wmissing-include-dirs  \
       -Wtrampolines -Wfloat-equal -Wshadow -Wmissing-prototypes -Wmissing-declarations          \
       -Wredundant-decls -Wnested-externs -Winline -Wno-variadic-macros -Wsign-conversion        \
       -Wsync-nand -Wunsafe-loop-optimizations -Wcast-align -Wstrict-overflow                    \
       -Wdeclaration-after-statement -Wundef -Wbad-function-cast -Wcast-qual -Wwrite-strings     \
       -Wlogical-op -Waggregate-return -Wstrict-prototypes -Wold-style-definition -Wpacked       \
       -Wvector-operation-performance -Wunsuffixed-float-constants -Wsuggest-attribute=const     \
       -Wsuggest-attribute=noreturn -Wsuggest-attribute=pure -Wsuggest-attribute=format          \
       -Wnormalized=nfkc -Wconversion -fstrict-aliasing -fstrict-overflow -fipa-pure-const       \
       -ftree-vrp -fstack-usage -funsafe-loop-optimizations

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

