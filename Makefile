.POSIX:

DEFAULT_PREFIX := /usr/local/bin
PREFIX ?= $(DEFAULT_PREFIX)
install_path := $(PREFIX)
encrypt_script := encrypt-file-aes256
decrypt_script := decrypt-file-aes256
distrib_name := openssl-encryption
this_file := $(lastword $(MAKEFILE_LIST))


.PHONY: check install uninstall distrib clean root-check


check: $(encrypt_script) $(decrypt_script)

	@echo; tput bold; tput setaf 3; echo Target: $@; tput sgr0; echo

	@if [ -f SHA512SUM ]; then \
		( \
			sha512sum -c SHA512SUM && \
			( tput bold; tput setaf 2; echo; echo "Ok. You may use 'sudo make install' or '(sudo) make install PREFIX=SomeDir' command now."; tput sgr0 ) || \
			( tput bold; tput setaf 1; echo; echo "Error: Script files hash sum mismatch!"; echo; tput sgr0; exit 1 ) \
		) \
	else \
		$(MAKE) -f $(this_file) SHA512SUM; \
	fi


install: check

	@echo; tput bold; tput setaf 3; echo Target: $@; tput sgr0; echo

	@[ $(PREFIX) = $(DEFAULT_PREFIX) ] || ( tput bold; tput setaf 4; echo "Information: Installing to non-standard location."; tput sgr0; echo )

	[ -d $(install_path) ] || mkdir -p $(install_path)
	install -v -m 0755 -t $(install_path) $(encrypt_script) $(decrypt_script)

	@tput bold; tput setaf 2; echo; echo "Ok. Scripts have been installed to '$(install_path)'."; tput sgr0


uninstall:

	@echo; tput bold; tput setaf 3; echo Target: $@; tput sgr0; echo

	rm $(install_path)/$(encrypt_script) $(install_path)/$(decrypt_script)
	rmdir $(install_path) 2> /dev/null || true

	@echo; tput bold; tput setaf 2; echo "Ok. The scripts have been uninstalled from '$(install_path)'."; tput sgr0


distrib: root-check SHA512SUM $(encrypt_script) $(decrypt_script) Makefile

	@echo; tput bold; tput setaf 3; echo Target: $@; tput sgr0; echo

	rm -f $(distrib_name).tar.xz $(distrib_name).tar.xz.asc
	rm -f -r $(distrib_name)
	mkdir $(distrib_name)
	cp $(encrypt_script) $(decrypt_script) Makefile SHA512SUM .safeclean-openssl-encryption $(distrib_name)
	wget -q -O $(distrib_name)/LICENSE https://git.io/fxByv
	wget -q -O $(distrib_name)/README https://git.io/fxByJ
	chmod 755 $(distrib_name)/$(encrypt_script) $(distrib_name)/$(decrypt_script)
	chmod 644 $(distrib_name)/Makefile $(distrib_name)/SHA512SUM $(distrib_name)/LICENSE $(distrib_name)/README
	tar -c -f $(distrib_name).tar $(distrib_name)/.
	xz -F xz -9 -e -C sha256 $(distrib_name).tar
	rm -f -r $(distrib_name)
	gpg -u 7D2E022E39A88ACF3EF6D4498F37AF4CE46008C3 -s -a -o $(distrib_name).tar.xz.asc -b $(distrib_name).tar.xz

	@echo; tput bold; tput setaf 2; echo "Ok. The archive and its signature have been saved as '$(distrib_name).tar.xz' and '$(distrib_name).tar.xz.asc'."; tput sgr0


clean: root-check

	@echo; tput bold; tput setaf 3; echo Target: $@; tput sgr0; echo

	@if [ ! -f .safeclean-$(distrib_name) ]; then \
		tput bold; tput setaf 1; echo "Error: Target '$@' has to be run from within its Makefile's directory!"; tput sgr0; echo; exit 1; \
	fi

	@ls -l | grep '^d' > /dev/null || echo "There are no more directories."

	@for dir in *; do \
		if [ -d "$${dir}" ]; then rm -f -r -v "$${dir}"; fi \
	done

	@rm -f -v $(distrib_name).tar.xz $(distrib_name).tar.xz.asc

	@echo; tput bold; tput setaf 2; echo "Ok. Directory clean successful."; tput sgr0


# https://www.gnu.org/software/make/manual/html_node/Force-Targets.html
force-rebuild-hash-file:


# real target file
SHA512SUM: force-rebuild-hash-file root-check $(encrypt_script) $(decrypt_script)

	@echo; tput bold; tput setaf 3; echo Target: $@; tput sgr0; echo

	rm -f $@
	sha512sum $(encrypt_script) $(decrypt_script) > $@

	@echo; tput bold; tput setaf 2; echo "Ok. The '$@' file has been (re-)generated."; tput sgr0


# special phony target with code for re-use; something like a function
root-check:

	@if [ $$(id -u) -eq 0 ]; then \
		echo; tput bold; tput setaf 3; echo $@; tput sgr0; echo; \
		tput bold; tput setaf 1; echo "Error: The target you invoked needs to be run as normal user!"; tput sgr0; echo; exit 1; \
	fi
