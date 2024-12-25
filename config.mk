SRC_ICON_FILE=$(SOURCE_DIR)/icon.png

MANUAL_URL  = https://www.gnu.org/prep/standards/standards.html_node.tar.gz
MANUAL_FILE = tmp/standards.html_node.tar.gz

$(MANUAL_FILE): tmp
	curl -o $@ $(MANUAL_URL)

$(DOCUMENTS_DIR): $(RESOURCES_DIR) $(MANUAL_FILE)
	mkdir -p $@
	tar -x -z -f $(MANUAL_FILE) -C $@

$(INDEX_FILE): $(SOURCE_DIR)/src/index-pages.py $(SCRIPTS_DIR)/gnu/index-terms-colon.py $(DOCUMENTS_DIR)
	rm -f $@
	$(SOURCE_DIR)/src/index-pages.py $@ $(DOCUMENTS_DIR)/*.html
	$(SCRIPTS_DIR)/gnu/index-terms-colon.py Entry $@ $(DOCUMENTS_DIR)/Index.html
