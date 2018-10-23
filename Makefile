.POSIX:


.SUFFIXES:


DEFAULT_PREFIX := /usr/local/bin
PREFIX ?= $(DEFAULT_PREFIX)
install_path := $(PREFIX)
encrypt_script := encrypt-file-aes256
decrypt_script := decrypt-file-aes256
distrib_name := openssl-encryption

platform_id = $$( uname -s )
platform = $$( \
	case $(platform_id) in \
		Linux | FreeBSD | OpenBSD | NetBSD ) echo $(platform_id) ;; \
		* ) echo Unrecognized ;; \
	esac )



# if [ $(platform_id) = Linux ] || \
#	[ $(platform_id) = FreeBSD ] || \
#	[ $(platform_id) = OpenBSD ] || \
#	[ $(platform_id) = NetBSD ]; \
#		then 
#		else ; \
#	fi







colors_supported != if command -v tput > /dev/null 2>&1 && tput setaf 1 > /dev/null 2>&1; then echo true; else echo false; fi
#header_color != if $(colors_supported); then tput bold && tput setaf 3; fi
#reset_colors != if $(colors_supported); then tput sgr0; fi


check: $(encrypt_script) $(decrypt_script)

	@echo; $(colors_supported) && ( tput bold; tput setaf 3 ) || true; echo Target: check; $(colors_supported) && tput sgr0 || true; echo


	@echo $(platform); echo
	@$$( exit 127 )
	









	
	@if ( if [ -f SHA512SUM ]; then \
			case $(platform) in \
				Linux ) sha512sum -c SHA512SUM ;; \
				FreeBSD ) shasum -a 512 -c SHA512SUM ;; \
				OpenBSD | NetBSD ) cksum -a sha512 -C SHA512SUM ;; \
				Unrecognized ) $(MAKE) SHA512SUM ;; \
			esac \
		fi ); \
	then ( \
		$(colors_supported) && ( tput bold; tput setaf 2 ) || true; \
		echo; echo "Ok. You may use 'sudo make install' or '(sudo) make install PREFIX=SomeDir' command now."; \
		$(colors_supported) && tput sgr0 || true \
	) else ( \
		$(colors_supported) && ( tput bold; tput setaf 1 ) || true; \
		echo; echo "Error: Script files hash sum mismatch!" 1>&2; \
		echo; $(colors_supported) && tput sgr0 || true; \
		exit 1 \
	); fi

#	&&  ( \
#		$(colors_supported) && ( tput bold; tput setaf 2 ); \
#		echo; echo "Ok. You may use 'sudo make install' or '(sudo) make install PREFIX=SomeDir' command now."; \
#		$(colors_supported) && tput sgr0 \
#		) \
#	||  ( \
#		$(colors_supported) && ( tput bold; tput setaf 1 ); \
#		echo; echo "Error: Script files hash sum mismatch!" 1>&2; \
#		echo; $(colors_supported) && tput sgr0; \
#		exit 1 \
#		)	 


install: check

	@echo; $(colors_supported) && tput bold && tput setaf 3; echo Target: install; $(colors_supported) && tput sgr0; echo

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
