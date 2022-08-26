.PHONY: install uninstall

install: uninstall
	sh ./install.sh
uninstall:
	sh ./uninstall.sh
test:
	nvim ./fnl/packs.fnl --startuptime test
