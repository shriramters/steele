# SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
# SPDX-License-Identifier: AGPL-3.0-only

# compiler
CYCLONE ?= cyclone

# dirs
SRC_DIR := src
LIB_DIR := $(SRC_DIR)/steele
TEST_DIR := tests

# install dirs
PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

# glob patterns
SRC_FILES := $(wildcard $(LIB_DIR)/*.scm) $(wildcard $(LIB_DIR)/*.scm) $(SRC_DIR)/main.scm
TEST_FILES := $(wildcard $(TEST_DIR)/*.scm)

TARGET := steele

.PHONY: all test install uninstall clean

all: $(TARGET)

$(TARGET): $(SRC_FILES)
	@echo "Compiling to native binary using cyclone..."
	$(CYCLONE) -I $(SRC_DIR)/ $(SRC_DIR)/main.scm
	@mv $(SRC_DIR)/main $(TARGET)
	@echo "Build Complete: please run ./$(TARGET)"

test: $(TEST_FILES)
	@echo "Building and running tests..."
	@for test_file in $(TEST_FILES); do \
		echo "Compiling $${test_file} to native binary using cyclone..."; \
		$(CYCLONE) -I $(SRC_DIR)/ $${test_file}; \
		echo "Compilation successful, now running $${test_file%.scm}"; \
		$${test_file%.scm}; \
	done;

install: all
	@echo "Installing steele to $(DESTDIR)$(BINDIR)"
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(TARGET) $(DESTDIR)$(BINDIR)

uninstall:
	@echo "Uninstalling steele from $(DESTDIR)$(BINDIR)/steele"
	rm -vf $(DESTDIR)$(BINDIR)/steele

clean:
	rm -vf $(TARGET)
	rm -vf $(SRC_DIR)/*.c $(SRC_DIR)/*.o
	rm -vf $(LIB_DIR)/*.c $(LIB_DIR)/*.o $(LIB_DIR)/*.meta $(LIB_DIR)/*.so
	rm -vf $(TEST_DIR)/*.c $(TEST_DIR)/*.o $(TEST_DIR)/*.meta $(TEST_DIR)/*.so
	@for test_file in $(TEST_FILES); do \
		rm -vf $${test_file%.scm};\
	done

