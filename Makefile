DESTDIR?=/usr/local/bin
install_path=$(DESTDIR)

script_name_1=encrypt-file-aes256
script_name_2=decrypt-file-aes256

user_id=$(shell whoami)
group_id=$(shell id -gn)

.PHONY: check
.PHONY: install
.PHONY: uninstall

check:
	[ -f $(script_name_1) ] && [ -f $(script_name_2) ] && sha512sum --check SHA512SUMS --status && echo "OK: Files are prepared. You may use make install command now." || echo "ERROR: Files are missing and / or hashsum mismatch!"

install:
	install --verbose --mode=0755 --owner=$(user_id) --group=$(group_id) --target-directory=$(install_path) $(script_name_1) $(script_name_2)

uninstall:
	rm $(install_path)/$(script_name_1) $(install_path)/$(script_name_2)