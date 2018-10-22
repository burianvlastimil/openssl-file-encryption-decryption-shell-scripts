.POSIX:


.SUFFIXES:


DEFAULT_PREFIX := /usr/local/bin
PREFIX ?= $(DEFAULT_PREFIX)
install_path := $(PREFIX)
encrypt_script := encrypt-file-aes256
decrypt_script := decrypt-file-aes256
distrib_name := openssl-encryption

color_support_test1 := $$( command -v tput > /dev/null 2>&1 )
#color_support_test2 := $$( tput setaf 1 > /dev/null 2>&1 )
colors_supported := $$( [ $(color_support_test1) -eq 0 ] )
#colors_available :=
# ) ] && echo true || echo false)


platform_id = $$(uname -s)

platform = $$( \
			 if [ $(platform_id) = Linux ] || \
				[ $(platform_id) = FreeBSD ] || \
				[ $(platform_id) = OpenBSD ] || \
				[ $(platform_id) = NetBSD ]; \
					then echo $(platform_id); \
					else echo Unrecognized; \
				fi \
			 )


check: $(encrypt_script) $(decrypt_script)



#	echo $(colors_supported)

	@if [ $(platform) = Unrecognized ]; then echo This platform: $(platform_id) is currently not supported.; else echo $(platform); fi

	exit 1






#	echo $(color_support_test)

	if [ $(colors_supported) = true ]; then echo I LOVE colors!; else echo I HATE colors!; fi

	exit 1













	@echo; if $(colors_supported); then tput bold; fi; $(colors_supported) && tput setaf 3; echo "Target: check"; $(colors_supported) && tput sgr0; echo

	@if [ -f SHA512SUM ]; then \
		( \
			if   [ $(platform_id) = Linux ]; then sha512sum -c SHA512SUM; \
			elif [ $(platform_id) = FreeBSD ]; then shasum -a 512 -c SHA512SUM; \
			elif [ $(platform_id) = OpenBSD ] || [ $(platform_id) = NetBSD ]; then cksum -a sha512 -C SHA512SUM; \
			fi && \
			( $(colors_supported) && tput bold; $(colors_supported) && tput setaf 2; echo; echo "Ok. You may use 'sudo make install' or '(sudo) make install PREFIX=SomeDir' command now."; $(colors_supported) && tput sgr0 ) || \
			( $(colors_supported) && tput bold; $(colors_supported) && tput setaf 1; echo; echo "Error: Script files hash sum mismatch!" 1>2; echo; $(colors_supported) && tput sgr0; exit 1 ) \
		) \
	else \
		$(MAKE) SHA512SUM; \
	fi


install: check

	@echo; $(colors_supported) && tput bold; $(colors_supported) && tput setaf 3; echo Target: install; $(colors_supported) && tput sgr0; echo

	@[ $(PREFIX) = $(DEFAULT_PREFIX) ] || ( $(colors_supported) && tput bold; $(colors_supported) && tput setaf 4; echo "Information: Installing to non-standard location."; $(colors_supported) && tput sgr0; echo )

	[ -d $(install_path) ] || mkdir -p $(install_path)
	install -v -m 0755 $(encrypt_script) $(decrypt_script) $(install_path)

	@$(colors_supported) && tput bold; $(colors_supported) && tput setaf 2; echo; echo "Ok. Scripts have been installed to '$(install_path)'."; $(colors_supported) && tput sgr0


uninstall:

	@echo; $(colors_supported) && tput bold; $(colors_supported) && tput setaf 3; echo Target: uninstall; $(colors_supported) && tput sgr0; echo

	rm $(install_path)/$(encrypt_script) $(install_path)/$(decrypt_script)
	rmdir $(install_path) 2> /dev/null || true

	@echo; $(colors_supported) && tput bold; $(colors_supported) && tput setaf 2; echo "Ok. The scripts have been uninstalled from '$(install_path)'."; $(colors_supported) && tput sgr0


distrib: root-check SHA512SUM $(encrypt_script) $(decrypt_script) Makefile

	@echo; $(colors_supported) && tput bold; $(colors_supported) && tput setaf 3; echo Target: distrib; $(colors_supported) && tput sgr0; echo

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

	@echo; $(colors_supported) && tput bold; $(colors_supported) && tput setaf 2; echo "Ok. The archive and its signature have been saved as '$(distrib_name).tar.xz' and '$(distrib_name).tar.xz.asc'."; $(colors_supported) && tput sgr0


clean: root-check

	@echo; $(colors_supported) && tput bold; $(colors_supported) && tput setaf 3; echo Target: clean; $(colors_supported) && tput sgr0; echo

	@if [ ! -f .safeclean-$(distrib_name) ]; then \
		$(colors_supported) && tput bold; $(colors_supported) && tput setaf 1; echo "Error: Target 'clean' has to be run from within its Makefile's directory!" 1>2; $(colors_supported) && tput sgr0; echo; exit 1; \
	fi

	@ls -l | grep '^d' > /dev/null || echo There are no more directories.

	@for dir in *; do \
		if [ -d "$${dir}" ]; then rm -f -r -v "$${dir}"; fi \
	done

	@rm -f -v $(distrib_name).tar.xz $(distrib_name).tar.xz.asc

	@echo; $(colors_supported) && tput bold; $(colors_supported) && tput setaf 2; echo "Ok. Directory clean successful."; $(colors_supported) && tput sgr0


# https://www.gnu.org/software/make/manual/html_node/Force-Targets.html
force-rebuild-hash-file:


# real target file
SHA512SUM: force-rebuild-hash-file root-check $(encrypt_script) $(decrypt_script)

	@echo; $(colors_supported) && tput bold; $(colors_supported) && tput setaf 3; echo Target: SHA512SUM; $(colors_supported) && tput sgr0; echo

	rm -f SHA512SUM

	@if echo $(platform_id) | grep -q Linux; then sha512sum $(encrypt_script) $(decrypt_script) > SHA512SUM; \
	elif echo $(platform_id) | grep -q BSD; then shasum -a 512 $(encrypt_script) $(decrypt_script) > SHA512SUM; \
	fi

	@echo; $(colors_supported) && tput bold; $(colors_supported) && tput setaf 2; echo "Ok. The 'SHA512SUM' file has been (re-)generated."; $(colors_supported) && tput sgr0


# special phony target with code for re-use; something like a function
root-check:

	@if [ $$(id -u) -eq 0 ]; then \
		echo; $(colors_supported) && tput bold; $(colors_supported) && tput setaf 3; echo root-check; $(colors_supported) && tput sgr0; echo; \
		$(colors_supported) && tput bold; $(colors_supported) && tput setaf 1; echo "Error: The target you invoked needs to be run as normal user!" 1>2; $(colors_supported) && tput sgr0; echo; exit 1; \
	fi
