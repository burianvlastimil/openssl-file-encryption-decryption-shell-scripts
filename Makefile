install_path=/usr/local/bin
script_name_1=encrypt-file-aes256
script_name_2=decrypt-file-aes256

.PHONY: install
.PHONY: uninstall

install:
	install -m 0755 -o root -g root -t $(install_path) $(script_name_1) $(script_name_2)

uninstall:
	rm $(install_path)/$(script_name_1) $(install_path)/$(script_name_2)